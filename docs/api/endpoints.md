# Veil API Endpoints

## Authentication
- POST /auth/anonymous → Anonymous login
- GET /auth/session → Fetch current session

## Messaging
- POST /message/send → Send encrypted message
- GET /message/:id → Retrieve message metadata

## Rooms
- POST /room/create → Create a temporary room
- GET /room/:id → Join a room
