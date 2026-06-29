# RapidRide — Customer Booking App

A modern, mobile-friendly ride-booking web application built with **React + Vite**, connected to an **Oracle APEX** database via ORDS REST APIs.

---

## Preview

> Customer login → Dashboard → Book a ride → Ride history → Profile

---

## Tech Stack

| Layer | Technology |
|---|---|
| Frontend | React 18 + Vite |
| Styling | CSS-in-JS (custom design system) |
| Backend | Oracle APEX (ORDS REST APIs) |
| Database | Oracle SQL — 13 tables |
| PL/SQL | Packages, Procedures, Functions, Triggers |

---

##  Project Structure

```
rapidride-client/
├── src/
│   └── App.jsx          # Full app (login, register, dashboard, booking, history, profile)
├── index.html
├── package.json
└── vite.config.js
```

---

##  Setup & Installation

### 1. Clone the repository

```bash
git clone https://github.com/YOUR_USERNAME/rapidride-client.git
cd rapidride-client
```

### 2. Install dependencies

```bash
npm install
```

### 3. Configure the API base URL

Open `src/App.jsx` and update line 6:

```js
const BASE_URL = "https://oracleapex.com/ords/rapidride/rapidride";
```

Replace with your actual Oracle APEX ORDS URL.

### 4. Run the development server

```bash
npm run dev
```

Open **http://localhost:5173** in your browser.

---

## 🔌 REST API Endpoints

All endpoints are created in Oracle APEX → SQL Workshop → RESTful Services → Module: `rapidride`

| Method | Endpoint | Description |
|---|---|---|
| POST | `/rapidride/login` | Customer login with ID + phone |
| POST | `/rapidride/register` | Register a new customer |
| GET | `/rapidride/locations` | Get all pickup/dropoff locations |
| GET | `/rapidride/vehicle-types` | Get all vehicle types with fares |
| POST | `/rapidride/book` | Book a new ride |
| GET | `/rapidride/rides/:customer_id` | Get ride history for a customer |

---

## 🗄️ Database Schema

The Oracle database contains **13 tables**:

- `customers` — registered app users
- `drivers` — driver profiles
- `vehicles` — vehicle records
- `vehicle_types` — car categories with fare rates
- `rides` — all ride bookings
- `payments` — payment records
- `reviews` — customer reviews
- `locations` — pickup/dropoff points
- `promotions` — discount codes
- `users` — admin/staff accounts
- `driver_documents` — driver document records
- `ride_events` — ride status change log
- `audit_log` — system audit trail

---

## 📱 App Features

- ✅ **Login** — Customer ID + phone number authentication
- ✅ **Register** — New customer registration (saved directly to Oracle DB)
- ✅ **Dashboard** — Stats, recent rides, quick book button
- ✅ **Book a Ride** — Select locations, vehicle type, distance with live fare preview
- ✅ **Ride History** — Full ride list with status badges
- ✅ **Profile** — Customer info and stats
- ✅ **Error handling** — All API errors shown gracefully
- ✅ **Loading indicators** — On every screen

---

## Build for Production

```bash
npm run build
```

Upload the `dist/` folder to any web host (Netlify, Vercel, GitHub Pages, etc.)

> Remember to update the **Origins Allowed** in your APEX module to your live domain.

---

## Author

**Dahran** — Built with Oracle APEX + React as a full-stack database project.

---

##  License

MIT License — free to use and modify.
