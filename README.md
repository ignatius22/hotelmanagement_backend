# Hotel Management Backend

This is the backend for the Hotel Management application, built with Ruby on Rails. It provides APIs for managing bookings, cabins, users, and other hotel-related operations.

---

## Table of Contents

- [Ruby Version](#ruby-version)
- [System Dependencies](#system-dependencies)
- [Configuration](#configuration)
- [Database Setup](#database-setup)
- [Running the Application](#running-the-application)
- [Running Tests](#running-tests)
- [Services](#services)
- [Deployment Instructions](#deployment-instructions)
- [API Endpoints](#api-endpoints)

---

## Ruby Version

- **Ruby**: `3.2.0`
- **Rails**: `7.1`

---

## System Dependencies

- **Database**: PostgreSQL
- **Authentication**: Devise with JWT
- **Background Jobs**: Sidekiq (optional)
- **Cache**: Redis (optional)

---

## Configuration

1. Clone the repository:
   ```bash
   git clone https://github.com/ignatius22/hotelmanagement_backend
   cd hotelmanagement_backend
   ```

2. Install dependencies:
   ```bash
   bundle install
   ```

3. Set up environment variables:
   - Create a `.env` file in the root directory.
   - Add the following variables:
     ```
     DATABASE_USERNAME=your_database_username
     DATABASE_PASSWORD=your_database_password
     JWT_SECRET_KEY=your_jwt_secret_key
     ```

4. Configure `config/database.yml` with your PostgreSQL credentials.

---

## Database Setup

1. Create the database:
   ```bash
   rails db:create
   ```

2. Run migrations:
   ```bash
   rails db:migrate
   ```

3. Seed the database:
   ```bash
   rails db:seed
   ```

---

## Running the Application

1. Start the Rails server:
   ```bash
   rails server
   ```

2. The application will be available at `http://localhost:3000`.

---

## Running Tests

Run the test suite using RSpec:
```bash
bundle exec rspec
```

---

## Services

- **Authentication**: Devise with JWT for secure user authentication.
- **Bookings Management**: APIs for creating, updating, and managing bookings.
- **Cabins Management**: APIs for managing cabin details.
- **Users Management**: APIs for user registration, login, and profile updates.

---

## Deployment Instructions

1. Precompile assets:
   ```bash
   rails assets:precompile
   ```

2. Push the code to your production server.

3. Run migrations on the production server:
   ```bash
   rails db:migrate RAILS_ENV=production
   ```

4. Start the application using a process manager like `puma` or `unicorn`.

---

## API Endpoints

### Authentication
- **POST** `/api/v1/users/sign_in`: Login
- **DELETE** `/api/v1/users/sign_out`: Logout

### Users
- **GET** `/api/v1/users/current`: Get current user details

### Cabins
- **GET** `/api/v1/cabins`: List all cabins
- **POST** `/api/v1/cabins`: Create a new cabin
- **PUT** `/api/v1/cabins/:id`: Update a cabin
- **DELETE** `/api/v1/cabins/:id`: Delete a cabin

### Bookings
- **GET** `/api/v1/bookings`: List all bookings
- **POST** `/api/v1/bookings`: Create a new booking
- **PUT** `/api/v1/bookings/:id`: Update a booking
- **DELETE** `/api/v1/bookings/:id`: Delete a booking

---

## Additional Notes

- Ensure you have Redis installed if you plan to use Sidekiq for background jobs.
- Use tools like Postman or cURL to test the API endpoints.

---

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.




