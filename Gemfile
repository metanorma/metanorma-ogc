source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}" }

gemspec

# TEMPORARY cross-PR pins (metanorma-core#18 wave) — identical block in
# every adoption PR; delete when the branches release.
gem "metanorma-core", github: "metanorma/metanorma-core", branch: "main"
gem "metanorma-standoc", github: "metanorma/metanorma-standoc", branch: "main"
gem "metanorma-document", github: "metanorma/metanorma-document", branch: "main"
# main carries the CitationStyle port: no lib/relaton load paths
gem "metanorma-iso", github: "metanorma/metanorma-iso", branch: "main"

# relaton v3 monogem + pubid-2 prerelease chain (isodoc PR#825)
# the pubid-2 line; render widened to the 3.0.0.pre family (isodoc #848)
gem "isodoc",
    github: "metanorma/isodoc",
    branch: "main"
gem "relaton-render", "~> 3.0.0.pre.alpha" # # canonical style packs; slot forms; bare from-only dates
gem "pubid", "~> 2.0.0.pre.alpha" # # relaton 3.0.0.pre.alpha.1 pairs with pre-rename pubid; .alpha.9 renamed base_identifier->base

# canonical line; the committed lock holds 0.8.29 which lacks map_any_element
gem "lutaml-model", "~> 0.8.107"
# released plugin-lutaml 0.7.50 lacks the preprocessor names standoc
# registers (LutamlDataPreprocessor); main carries them (generic#133)
gem "metanorma-plugin-lutaml", github: "metanorma/metanorma-plugin-lutaml", branch: "main"
