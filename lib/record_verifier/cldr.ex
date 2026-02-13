defmodule RecordVerifier.Cldr do
  use Cldr,
    locales: ["en-PH", "fil-PH"],
    default_locale: "en-PH",
    providers: [Cldr.Number, Money]
end
