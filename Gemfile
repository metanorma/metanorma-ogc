source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}" }

gemspec

# TEMPORARY cross-PR pins (metanorma-core#18 wave) — identical block in
# every adoption PR; delete when the branches release.
gem "metanorma-core", "~> 0.2.7" # published flavor/taste table (metanorma-core#18)
gem "metanorma-standoc", "~> 3.5.7" # feat/move-standard-document is released
gem "metanorma-document", "~> 0.5.3" # feat/model-validation-l1-declarations is released
# 0.1.5 carries the ceradoc migration (coradoc → coridoc → ceradoc,
# 2026-11-25): the descriptions renderer converts through the ceradoc
# hub (ceradoc ~> 3.0 + ceradoc-markdown + ceradoc-adoc), resolvable
# alongside metanorma-plugin-lutaml 0.7.83 which pins the same line.
gem "metanorma-plugin-openapi", "~> 0.1.5"
# main carries the CitationStyle port: no lib/relaton load paths
gem "metanorma-iso", github: "metanorma/metanorma-iso", branch: "main"

# relaton v3 monogem + pubid-2 prerelease chain (isodoc PR#825)
# the pubid-2 line; render widened to the 3.0.0.pre family (isodoc #848)
gem "isodoc", "~> 3.7.9" # rt-pubid-2-migration is released
gem "pubid", "~> 2.0"

gem "relaton", "~> 3.1.1"
