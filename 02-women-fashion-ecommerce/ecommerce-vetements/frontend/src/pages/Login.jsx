import React, { useState, useEffect } from "react";
import { Link, useNavigate } from "react-router-dom";
import { FaFacebookF, FaEnvelope, FaMapMarkerAlt, FaInstagram, FaFacebook, FaTiktok, FaClock } from "react-icons/fa";
import { FcGoogle } from "react-icons/fc";
import { FiSearch, FiUser, FiHeart, FiBell, FiPhone } from "react-icons/fi";
import axios from "axios";
import "./Home.css";
import login from "./login.png";

const Login = () => {
  const navigate = useNavigate();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [user, setUser] = useState(null);
  const [showMenu, setShowMenu] = useState(false);

  const handleLogin = async (e) => {
    e.preventDefault();
    if (!email || !password) {
      alert("Please fill all fields");
      return;
    }
    try {
      const res = await axios.post("http://localhost:5000/api/auth/login", {
        email,
        password,
      });
      localStorage.setItem("user", JSON.stringify(res.data.user));
      alert("Login successful!");
      navigate("/"); 
    } catch (error) {
      alert(error.response?.data?.message || "Login failed");
    }
  };

  useEffect(() => {
    const savedUser = localStorage.getItem("user");
    if (savedUser) {
      setUser(JSON.parse(savedUser));
    }
  }, []);
  
  const handleLogout = () => {
    const confirmLogout = window.confirm("Do you really want to log out?");
    if (confirmLogout) {
      localStorage.removeItem("user");
      setUser(null);
      navigate("/login");
    }
  };

  return (
    <div className="login-container">
      <header className="navbar">
        <div className="navbar-left">
          <div className="logo">LadyCham</div>
            <a href="#home" className="nav-link">Home</a>
            <a href="#home" className="nav-link">Promotion</a>
            <a href="#contact" className="nav-link">Contact</a>
            {!user && <Link to="/login" className="nav-link">Login</Link>}
            {!user && <Link to="/signup" className="nav-link">Sign Up</Link>}
          </div>
          <div className="navbar-right">
            <button className="icon-button"><FiSearch className="icon" /></button>
            <div className="user-menu">
              <button
                className="icon-button"
                onClick={() => setShowMenu(!showMenu)}
              >
                <FiUser className="icon" />
              </button>
              {showMenu && (
                <div className="dropdown-menu">
                  {!user ? (
                    <>
                      <Link to="/login">Login</Link>
                    </>
                    ) : (
                    <>
                      <p className="user-name">Hello {user.name}</p>
                      <Link to="/reviews">My Reviews</Link>
                      <hr className="dropdown-divider" />
                      <Link to="/orders">My Orders</Link>
                      <hr className="dropdown-divider" />
                      <button className="logout-btn" onClick={handleLogout}>
                        Log out
                      </button>
                    </>
                  )}
                </div>
              )}
            </div>
            <button className="icon-button"><FiHeart className="icon"><span className="badge"></span></FiHeart></button>
            <button className="icon-button"><FiBell className="icon"><span className="badge"></span></FiBell></button>
          </div>
        </header>
        <div className="login-image">
          <img src={login} alt="login" />
        </div>
        <div className="login-form">
          <h1 className="welcome-text">Welcome back girls!</h1>
          <form onSubmit={handleLogin}>
            <div className="form-group">
              <label>Email</label>
              <input
                type="email"
                placeholder="Enter email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
              />
            </div>
            <div className="form-group">
              <label>Password</label>
              <input
                type="password"
                placeholder="Enter password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
              />
              <Link to="/forgot-password" className="forgot-link">
                Forgot password?
              </Link>
            </div>
            <div className="login-options">
              <label>
                <input type="checkbox" /> Remember me
              </label>
            </div>
            <button className="login-btn" type="submit">Login</button>
            <p className="signup-text">
              New here? <Link to="/signup">Create an account</Link>
            </p>
            <div className="divider">
              <span>Or sign in with</span>
            </div>
            <button className="social-btn google" type="button">
              <FcGoogle /> Continue with Google
            </button>
            <button className="social-btn facebook" type="button">
              <FaFacebookF /> Continue with Facebook
            </button>
          </form>
        </div>
      </div>
  );
};

export default Login;