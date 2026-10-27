source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}" }

gemspec

# TEMPORARY cross-PR pins (metanorma-core#18 wave) — identical block in
# every adoption PR; delete when the branches release.
gem "metanorma-core", github: "metanorma/metanorma-core", branch: "feat/flavor-table"
gem "metanorma-standoc", "~> 3.5.1.pre.alpha" # feat/move-standard-document is released
gem "metanorma-document", "~> 0.5.2.pre.alpha" # feat/model-validation-l1-declarations is released
# metanorma-plugin-openapi#4 — released 0.1.0 hard-requires
# coradoc/markdown, unresolvable under metanorma-plugin-lutaml's
# coradoc ~> 1.1.8; drop for the release carrying the soft-coradoc fix
gem "metanorma-plugin-openapi", github: "metanorma/metanorma-plugin-openapi", branch: "main"
# main carries the CitationStyle port: no lib/relaton load paths
gem "metanorma-iso", github: "metanorma/metanorma-iso", branch: "main"

# relaton v3 monogem + pubid-2 prerelease chain (isodoc PR#825)
# the pubid-2 line; render widened to the 3.0.0.pre family (isodoc #848)
gem "isodoc", "~> 3.7.4.pre.alpha" # rt-pubid-2-migration is released
gem "relaton-render", "~> 3.0" # canonical style packs; slot forms; bare from-only dates
gem "pubid", "~> 2.0"
