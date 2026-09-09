# Shoply - Product Listing App

A small Flutter product browser built for the interview exercise. It fetches products from the [Fake Store API](https://fakestoreapi.com/products), supports local search and category filtering, and includes product details, favorites, and a cart badge.

## Run locally

```bash
flutter pub get
flutter run
```

Run the checks with:

```bash
flutter analyze
flutter test
```

## Structure

- `lib/models`: API/domain models
- `lib/data`: HTTP API client and response validation
- `lib/logic`: Cubits for product UI state and cart state
- `lib/screens`: home and detail screens
- `lib/widgets`: reusable product card

`flutter_bloc` keeps network state and UI interactions out of the widgets. Favorites and cart contents are intentionally in-memory because persistence and a full cart screen were optional for this exercise.

## Assumptions

The API is treated as an external dependency: loading, HTTP/format errors, retry, and empty filtered results are all represented in the UI. Product images are loaded remotely and show a fallback icon if an image cannot be displayed.
