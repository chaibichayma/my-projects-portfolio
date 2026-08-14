import React, { useState, useEffect } from "react";
import { Link, useNavigate } from "react-router-dom";
import { FaFacebookF, FaEnvelope, FaMapMarkerAlt, FaInstagram, FaFacebook, FaTiktok, FaClock } from "react-icons/fa";
import { FcGoogle } from "react-icons/fc";
import { FiSearch, FiUser, FiHeart, FiBell, FiPhone } from "react-icons/fi";
import axios from "axios";
import "./Home.css";
import login from "./login.png";

const Signup = () => {
  const navigate = useNavigate();
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [user, setUser] = useState(null);
  const [showMenu, setShowMenu] = useState(false);

  const handleSignup = async (e) => {
    e.preventDefault();
    if (!name || !email || !password || !confirmPassword) {
      alert("Please fill all fields");
      return;
    }
    if (password.length < 6) {
      alert("Password must be at least 6 characters");
      return;
    }
    if (password !== confirmPassword) {
      alert("Passwords do not match");
      return;
    }
    try {
      await axios.post("http://localhost:5000/api/auth/signup", { name, email, password });
      alert("Account created successfully!");
      navigate("/"); 
    } catch (error) {
      alert(error.response?.data?.message || "Something went wrong");
    }
  };

  useEffect(() => {
    const savedUser = localStorage.getItem("user");
    if (savedUser) {
      setUser(JSON.parse(savedUser));
    }
  }, []);
    
  const handleLogout = () => {
    const confirmLogout = window.confirm("Do you really want to log out ?");
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
          <img src={login} alt="signup" />
        </div>
        <div className="login-form">
          <h1 className="welcome-text">Create your account</h1>
          <form onSubmit={handleSignup}>
            <div className="form-group">
              <label>Full Name</label>
              <input
                type="text"
                placeholder="Enter your full name"
                value={name}
                onChange={(e) => setName(e.target.value)}
              />
            </div>
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
            </div>
            <div className="form-group">
              <label>Confirm Password</label>
              <input
                type="password"
                placeholder="Confirm password"
                value={confirmPassword}
                onChange={(e) => setConfirmPassword(e.target.value)}
              />
            </div>
            <button className="login-btn" type="submit">Sign Up</button>
            <p className="signup-text">
              Already have an account? <Link to="/login">Login</Link>
            </p>
            <div className="divider">
              <span>Or sign up with</span>
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

export default Signup;