Decoder examples
================

This repository has some examples for decoding JSON in Elm.

The code was originally produced at a live-coding session in an [Elmsinki meetup](https://www.meetup.com/Elmsinki/events/236789669).


## What to find here

- `Decoders.elm` is a simpler example
  - "hard-coded" JSON value
  - decoder for a union type (`type Sex = Male | Female | Unknown`)
  - decoder for JSON objects using the union type decoder
  - list decoder for a list of the objects

- `DecoderDate.elm` is a more real-life example
  - we use an [actual response](json/03-commits.json) from the GitHub API, with an HTTP request
  - decoder for selected data from nested objects in a list
  - decoder for turning an ISO date string into an Elm `Date`
