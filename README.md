# Shopping Cart Web Application

## Problem Solved
Single-page app for browsing products and managing a shopping cart (add, update quantity, remove). Full CRUD operations with MySQL database. Multi‑user support via dropdown (users 1,2,3), each with independent cart.

## Tech Stack
- Frontend: React + Vite (JavaScript)
- Styling: Custom CSS
- Backend: Django + Django REST Framework (Python)
- Database: MySQL

## Features
- View all products with prices
- Add to cart, update quantity, remove items
- Cart total auto‑recalculates
- User‑specific cart isolation
- Responsive card layout

## Folder Structure
ASS1/
├── BackEnd/ # Django project
│ ├── ass1/ # main app
│ ├── backend/ # settings
│ └── manage.py
├── FrontEnd/ # React + Vite
│ ├── src/ # components, CSS
│ └── package.json
├── ass1_db.sql # MySQL dump
├── requirements.txt # Python dependencies
├── .gitignore
└── README.md



## How to Run (Windows)

### Backend
1. Open terminal in `ASS1/BackEnd`
2. Create & activate virtual environment (optional, but recommended):  
   `.venv\Scripts\activate`
3. Install Python dependencies:  
   `pip install -r requirements.txt`
4. Run migrations:  
   `python manage.py migrate`
5. Start Django server:  
   `python manage.py runserver`  
   → `http://127.0.0.1:8000`

### Frontend
1. Open another terminal in `ASS1/FrontEnd`
2. Install npm dependencies:  
   `npm install`
3. Start Vite dev server:  
   `npm run dev`  
   → `http://localhost:5173`

### Use the app
- Open `http://localhost:5173`
- Select a user (1, 2, 3) from the dropdown
- Add products, edit cart, delete items

## Database Import (if needed)
To restore the database manually:  
`mysql -u root -p ass1_db < ass1_db.sql`

## Challenges Overcome
- CORS configuration between React (port 5173) and Django (port 8000).
- Many‑to‑many cart logic (Cart ↔ CartItem ↔ Product).
- Multi‑user isolation using `user_id` query parameter.
- DELETE requests with body in Django REST Framework.
- Clean, responsive UI without external CSS frameworks.