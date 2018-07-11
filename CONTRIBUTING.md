## Contributing

### Code Style

* This project uses rubocop. Get it with ``gem install rubocop`` and then run ``rubocop --auto-correct`` inside the git repo to fix all formating problems automatically. More sever code style violations may need some manual attention. PR's without rubocop applied are not being merged.

  Rubocop Style Reference: https://rubocop.readthedocs.io/en/latest/cops_style/

* Fasterer is a tool that will suggest speed improvements for your ruby code. It is highly recommended to use on bigger changes to keep the Canuby code fast. Get it with ``gem install fasterer`` and then run ``fasterer`` inside the git repo to get the code flash fast. **Note** Currently not working correctly for unknown reasons.


### Testing

To run the Canuby tests use ``rake test`` in the root directory.


### Documenting

Canuby uses yardoc to generate the docs. They are available here  [![GitHub Downloads](https://img.shields.io/badge/Canuby-doc-brightgreen.svg?logo=github&maxAge=1200)](https://github.com/SuperSandro2000/canuby/releases). To update the documentation manually run ``rake yard``. Travis updates the online documentation automatically.
