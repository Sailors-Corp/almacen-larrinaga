import 'api_constants.dart';

/// Public storefront base URL of the Bagisto shop.
///
/// Derived from the configured GraphQL endpoint origin, mirroring how
/// `account_models`, `returns_models` and `downloadable_products_page`
/// build public links (`Uri.parse(bagistoEndpoint).origin`).
///
/// Used to resolve relative CMS/banner/footer URLs coming from the API
/// (for example `storage/...` images or footer links).
final String bagistoPublicBaseUrl = Uri.parse(bagistoEndpoint).origin;
