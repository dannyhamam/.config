/**
 * Registers every locally installed Ollama model with OpenCode at startup.
 *
 * `ollama pull <model>` is all that's needed for a model to appear in the
 * picker -- nothing has to be added to opencode.jsonc. OpenCode has no native
 * local-model discovery, so this fills that gap via the `config` hook.
 */

const HOST = process.env.OLLAMA_HOST_URL ?? "http://127.0.0.1:11434"

// Ollama sizes its own KV cache to fit available RAM, so a model's *native*
// context is usually far more than the server will actually hold (qwen3.6
// advertises 262144; Ollama loads it at 32768 on a 36GB machine). Reporting the
// native number makes OpenCode skip compaction and silently overflow into
// Ollama's --context-shift, which quietly drops the earliest turns. Clamp so
// OpenCode compacts before that happens.
const MAX_CONTEXT = Number(process.env.OPENCODE_OLLAMA_MAX_CONTEXT ?? 32768)
const MAX_OUTPUT = Number(process.env.OPENCODE_OLLAMA_MAX_OUTPUT ?? 8192)

async function api(path, body) {
  const res = await fetch(HOST + path, {
    method: body ? "POST" : "GET",
    ...(body ? { body: JSON.stringify(body) } : {}),
    signal: AbortSignal.timeout(5000),
  })
  if (!res.ok) throw new Error(path + " -> " + res.status)
  return res.json()
}

async function describe(id) {
  const info = await api("/api/show", { model: id })
  const caps = info.capabilities ?? []
  const arch = info.model_info?.["general.architecture"]
  const native = info.model_info?.[arch + ".context_length"]
  const context = Number.isFinite(native) ? Math.min(native, MAX_CONTEXT) : MAX_CONTEXT
  return {
    name: id,
    tool_call: caps.includes("tools"),
    reasoning: caps.includes("thinking"),
    attachment: caps.includes("vision"),
    limit: { context, output: Math.min(MAX_OUTPUT, context) },
  }
}

export const OllamaAutoload = async () => ({
  config: async (config) => {
    let tags
    try {
      tags = await api("/api/tags")
    } catch {
      return // Ollama isn't running -- leave the config exactly as-is
    }

    const models = {}
    await Promise.all(
      (tags.models ?? []).map(async (m) => {
        try {
          models[m.model] = await describe(m.model)
        } catch {
          // Metadata lookup failed; register with conservative defaults rather
          // than hiding the model entirely.
          models[m.model] = {
            name: m.model,
            tool_call: true,
            limit: { context: MAX_CONTEXT, output: MAX_OUTPUT },
          }
        }
      }),
    )

    if (!Object.keys(models).length) return

    const existing = config.provider?.ollama ?? {}
    config.provider ??= {}
    config.provider.ollama = {
      npm: "@ai-sdk/openai-compatible",
      name: "Ollama (local)",
      options: { baseURL: HOST + "/v1" },
      ...existing,
      // Discovered models first so anything hand-tuned in opencode.jsonc wins.
      models: { ...models, ...(existing.models ?? {}) },
    }
  },
})
