-- JDTLS
require("jdtls").start_or_attach({
    flags = {
        debounce_text_changes = 80,
    },
    init_options = {
        bundles = {
            vim.fn.glob(
                "/home/erice/.local/share/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar",
                true)
        },
    },
    cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/jdtls") },
    root_dir = vim.fs.dirname(vim.fs.find({ ".gradlew", ".git", "mvnw" }, { upward = true })[1]),
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        java = {
            format = {
                settings = {
                    -- Use Google Java style guidelines for formatting
                    -- To use, make sure to download the file from https://github.com/google/styleguide/blob/gh-pages/eclipse-java-google-style.xml
                    -- and place it in the ~/.local/share/eclipse directory
                    url = "/.local/share/eclipse/eclipse-java-google-style.xml",
                    profile = "GoogleStyle",
                },
            },
            favoriteStaticMembers = {
                "org.hamcrest.MatcherAssert.assertThat",
                "org.hamcrest.Matchers.*",
                "org.hamcrest.CoreMatchers.*",
                "org.junit.jupiter.api.Assertions.*",
                "java.util.Objects.requireNonNull",
                "java.util.Objects.requireNonNullElse",
                "org.mockito.Mockito.*"
            },
            signatureHelp = { enabled = true },
            completion = {
                filteredTypes = {
                    "com.sun.*",
                    "io.micrometer.shaded.*",
                    "java.awt.*",
                    "jdk.*", "sun.*"
                }
            },
            -- Specify any options for organizing imports
            sources = {
                organizeImports = {
                    starThreshold = 9999,
                    staticStarThreshold = 9999,
                },
            },
            -- How code generation should act
            codeGeneration = {
                toString = {
                    template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
                },
                hashCodeEquals = {
                    useJava7Objects = true,
                },
                useBlocks = true,
            },
        }
    }
})

require('jdtls.dap').setup_dap_main_class_configs()
