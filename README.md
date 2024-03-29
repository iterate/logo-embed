# ⚠️ FLYTTA TIL https://github.com/iterate/logo-embed2 ⚠️

# Logo

## Konfig

For å bygge firmware må man sette tre miljøvariabler der man bygger fra.

`MIX_TARGET` skal antakeligvis være `rpi3` som betyr at vi bygger for Raspberry 3.

`NERVES_NETWORK_SSID` og `NERVES_NETWORK_PSK` som er navnet og passordet til
WiFi-en **Logo** skal koble seg til.

## Bygg

```shell
mix firmware
```

## Deploy

Slik det er nå kan den som har bygd nåværende firmware pushe ny firmware over
SSH med `mix firmware.push nerves.local`. Si ifra om du har lyst til å pushe
firmware, så finner vi en ordning.

## Les deg opp

- [**Elixir**](https://elixir-lang.org) er språket **Logo** er skrevet i.
- [**Raspberry Pi**](https://www.raspberrypi.org/) er skikkelig liten datamaskin.
- [**Nerves**](https://nerves-project.org) er prosjektet som gjør det praktisk å
  kjøre Elixir på en Raspberry Pi.
- [**WS2812B**](https://cdn-shop.adafruit.com/datasheets/WS2812B.pdf) er en
  type LED som teoretisk kan vise 1677216 forskjellige farger.
- [**Neopixel**](https://learn.adafruit.com/adafruit-neopixel-uberguide/the-magic-of-neopixels)
  er en type "smarte" RGB(W) LEDs (WS2812B) fra
  [**Adafruit**](https://adafruit.com). Vår ambisjon er å bruke 43
  [**Neopixel-matriser**](https://www.adafruit.com/product/1487)
  (enten fra Adafruit eller China).
- [**blinkchain**](https://github.com/GregMefford/blinkchain) er et bibliotek
  gjør det praktisk å kontrollere Neopixels fra Nerves.
