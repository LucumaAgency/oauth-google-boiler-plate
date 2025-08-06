const express = require('express');
const passport = require('passport');
const session = require('express-session');
const cors = require('cors');
const { connectDB } = require('./config/database');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors({
  origin: process.env.CLIENT_URL || 'http://localhost:5173',
  credentials: true
}));

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use(session({
  secret: process.env.SESSION_SECRET || 'your-secret-key',
  resave: false,
  saveUninitialized: false,
  cookie: {
    secure: process.env.NODE_ENV === 'production',
    httpOnly: true,
    maxAge: 24 * 60 * 60 * 1000
  }
}));

app.use(passport.initialize());
app.use(passport.session());

// Connect to MariaDB
connectDB();

require('./config/passport')(passport);

app.use('/auth', require('./routes/auth'));
app.use('/api/user', require('./routes/user'));

// Serve static files from React build
const path = require('path');
if (process.env.NODE_ENV === 'production') {
  app.use(express.static(path.join(__dirname, 'client/dist')));
  
  app.get('*', (req, res) => {
    res.sendFile(path.join(__dirname, 'client/dist', 'index.html'));
  });
} else {
  app.get('/', (req, res) => {
    res.json({ message: 'OAuth Google Boilerplate API with MariaDB' });
  });
}

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});