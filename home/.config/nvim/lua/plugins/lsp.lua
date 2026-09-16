return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- Inlay hints: greyed-out inferred types and parameter names rendered
      -- inside the line. Enormously useful in Go and TypeScript.
      -- Toggle at runtime with <leader>uh.
      inlay_hints = { enabled = true },

      -- Show the diagnostic message inline (matches config/options.lua).
      diagnostics = {
        virtual_text = { spacing = 4, source = "if_many", prefix = "●" },
        severity_sort = true,
      },

      servers = {
        -- gopls: LazyVim's lang.go extra already configures this well.
        -- These are the extras worth having on a Razorpay Go codebase.
        gopls = {
          -- Installed manually with `go install golang.org/x/tools/gopls@latest`
          -- because proxy.golang.org times out through Mason here.
          -- mason = false tells LazyVim to use the one on PATH instead.
          mason = false,
          settings = {
            gopls = {
              gofumpt = true, -- stricter gofmt
              staticcheck = true, -- catch real bugs, not just vet
              usePlaceholders = true, -- fill function params on completion
              analyses = {
                unusedparams = true,
                unusedwrite = true,
                nilness = true, -- nil-deref analysis
                shadow = true, -- shadowed variable detection
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
            },
          },
        },

        -- YAML: you have kube-manifests and alert-rules, so schema-aware
        -- completion for Kubernetes objects is worth it.
        yamlls = {
          settings = {
            yaml = {
              keyOrdering = false, -- don't nag about key order
            },
          },
        },
      },
    },
  },
}
