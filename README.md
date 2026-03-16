# Admin Panel (Flutter + Supabase)

Admin dashboard app for managing store data from a Flutter client backed by Supabase.

This README includes:

- `System Documentation` (for developers/maintainers)
- `User Documentation` (for admins using the app)

## 1) Project Overview

This app provides admin features for:

- Authentication (email/password, Google OAuth entry point)
- Dashboard metrics (total users, total products, total categories)
- Category management (add + list)
- Product management (add + list)

Core stack:

- Flutter (Material UI)
- Riverpod (state management)
- Supabase (auth, database, storage)

## 2) System Documentation

### 2.1 Architecture

The code follows a light feature-first structure:

- `lib/core`: shared providers (Supabase client)
- `lib/data`: repositories for database/storage access
- `lib/presentation`: UI screens + Riverpod providers/notifiers

Pattern used in features:

- UI screen reads Riverpod provider state
- Notifier calls repository methods
- Repository talks to Supabase tables/storage

### 2.2 Key Dependencies

From `pubspec.yaml`:

- `flutter_riverpod`
- `supabase_flutter`
- `image_picker`
- `path`

### 2.3 Entry Point and App Boot

Main file: `lib/main.dart`

Current behavior:

- Calls `Supabase.initialize(...)`
- Starts app with `ProviderScope`
- Opens `AdminLoginPage` as home route

Important note:

- Supabase URL and anon key are currently hardcoded in `lib/main.dart`.
- For production, move them to secure config/environment.

### 2.4 Module Map

Auth:

- `lib/presentation/login/provider/auth_controller.dart`
- `lib/presentation/sign_up/provider/sign_up_state.dart`
- `lib/presentation/login/login_page.dart`
- `lib/presentation/sign_up/sign_up.dart`

Dashboard:

- `lib/presentation/home_dash/provider/dashboard_provider.dart`
- `lib/presentation/home_dash/ui/home_page.dart`
- `lib/presentation/home_dash/ui/container_home.dart`

Category:

- `lib/presentation/category/provider/category_provider.dart`
- `lib/data/category_data/category_repository.dart`
- `lib/presentation/category/ui/addnew_category.dart`
- `lib/presentation/category/ui/category_list_page.dart`
- `lib/presentation/category/ui/category_card.dart`

Product:

- `lib/presentation/product/provider/product_provider.dart`
- `lib/data/product/product_repo.dart`
- `lib/presentation/product/ui/add_product.dart`
- `lib/presentation/product/ui/product_list_page.dart`
- `lib/presentation/product/ui/product_card.dart`

### 2.5 Supabase Integration

Client provider:

- `lib/core/supabase_provider.dart`

Tables used by code:

- `category`
- `sub_category`
- `products`
- user count candidates for dashboard: `users`, `profiles`, `user`

Storage buckets used by code:

- Category images: `category`
- Product images: tries `products`, then `product` (fallback)

If product upload fails because bucket is missing, repository throws a helpful error asking to create `products` or `product` bucket.

### 2.6 Minimal Data Requirements

The app expects these columns at minimum:

`category` table:

- `id`
- `name`
- `image_url`
- `created_at` (used for ordering)

`sub_category` table:

- `id`
- `name`
- `category_id` (FK to category)

`products` table:

- `id`
- `name`
- `price`
- `image_url`
- `sub_category_id` (FK to sub_category)

### 2.7 Dashboard Metrics Logic

In `dashboard_provider.dart`:

- Total categories = row count of `category`
- Total products = row count of `products`
- Total users = first readable table among `users`, `profiles`, `user`
- If user tables do not exist, the provider returns `0`

UI layout:

- Cards are rendered in 2-column grid on dashboard.

### 2.8 Setup and Run

Prerequisites:

- Flutter SDK (matching Dart SDK `^3.10.1`)
- Supabase project with required tables and buckets

Install dependencies:

```bash
flutter pub get
```

Run app:

```bash
flutter run
```

Analyze:

```bash
flutter analyze
```

Tests:

```bash
flutter test
```

### 2.9 Common Issues and Fixes

Subcategory dropdown empty:

- Ensure `sub_category.category_id` matches selected category IDs.
- Check that subcategories exist for the chosen category.

Product not inserted:

- App now shows insert/upload error in snackbar.
- Validate RLS policies for table insert and storage upload.

Bucket not found:

- Create storage bucket `products` (recommended) or `product`.

Dashboard user count shows 0:

- This means no `users/profiles/user` table was readable.
- Configure the desired user profile table if needed.

### 2.10 Current Limitations

- Category card tap currently has no action.
- `edit_product.dart` exists as a basic placeholder UI.
- Supabase credentials are in code (should be moved to environment config).

## 3) User Documentation (Admin Guide)

### 3.1 Login

1. Open the app.
2. Enter admin email and password.
3. Tap `Login`.
4. On success, you are redirected to `Admin Dashboard`.

Optional:

- `Sign Up` screen allows creating a new admin account.

### 3.2 Dashboard

Top cards show live totals:

- `Total Users`
- `Total Products`
- `Total Categories`

Cards are shown in a 2-cards-per-row layout.

### 3.3 Add Category

1. In `Manage Categories`, tap `Add New Category`.
2. Enter category name.
3. Select image from gallery.
4. Tap `Add Category`.
5. If successful, page closes and category list refreshes.

### 3.4 View Categories

- Categories are shown in a horizontal list under `Manage Categories`.
- Each card shows category image and name.

### 3.5 Add Product

1. In `Manage Products`, tap `Add New Product`.
2. Enter product name.
3. Select category.
4. Select subcategory.
5. Enter price.
6. Select image.
7. Tap `Add Product`.

Validation in app:

- Product name required
- Price must be valid and > 0
- Category/subcategory/image required

### 3.6 View Products

- Products are shown in a horizontal list under `Manage Products`.
- Each card shows product image, name, and price.

## 4) Recommended Production Improvements

- Move Supabase URL/key to secure environment handling.
- Add full CRUD for category and product.
- Add robust role-based access control.
- Add pagination and search for large datasets.
- Add integration tests for auth/data flows.

## 5) Quick File Reference

- App boot: `lib/main.dart`
- Supabase provider: `lib/core/supabase_provider.dart`
- Dashboard: `lib/presentation/home_dash/ui/home_page.dart`
- Category add/list: `lib/presentation/category/ui/addnew_category.dart`
- Product add/list: `lib/presentation/product/ui/add_product.dart`
