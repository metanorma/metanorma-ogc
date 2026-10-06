source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}" }

gemspec

# TEMPORARY cross-PR pins (metanorma-core#18 wave) — identical block in
# every adoption PR; delete when the branches release.
gem "metanorma-core", github: "metanorma/metanorma-core", branch: "feat/flavor-table"
gem "metanorma-standoc", github: "metanorma/metanorma-standoc", branch: "feat/move-standard-document"
gem "metanorma-document", github: "metanorma/metanorma-document", branch: "feat/model-validation-l1-declarations"
# main carries the CitationStyle port: no lib/relaton load paths
gem "metanorma-iso", github: "metanorma/metanorma-iso", branch: "main"

# relaton v3 monogem + pubid-2 prerelease chain (isodoc PR#825)
# the pubid-2 line; render widened to the 3.0.0.pre family (isodoc #848)
gem "isodoc",
    github: "metanorma/isodoc",
    branch: "rt-pubid-2-migration"
gem "relaton-render", "= 3.0.0.pre.alpha.19"
gem "relaton-cli", ">= 3.0.0.pre.alpha.1"
gem "pubid", "2.0.0.pre.alpha.8" # relaton 3.0.0.pre.alpha.1 pairs with pre-rename pubid; .alpha.9 renamed base_identifier->base
