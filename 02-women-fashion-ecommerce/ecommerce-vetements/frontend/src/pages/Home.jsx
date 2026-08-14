import React, { useEffect, useState } from "react";
import "./Home.css";
import { FiSearch, FiUser, FiHeart, FiBell, FiPhone } from "react-icons/fi";
import { FaEnvelope, FaMapMarkerAlt, FaInstagram, FaFacebook, FaTiktok, FaClock } from "react-icons/fa";
import heroImg from "./image1.png";
import axios from "axios";
import { Link, useNavigate } from "react-router-dom";

const Home = () => {

  const [categories, setCategories] = useState([]);
  const [user, setUser] = useState(null);
  const [showMenu, setShowMenu] = useState(false);
  const navigate = useNavigate();

  useEffect(() => {
    const fetchCategories = async () => {
      try {
        const res = await axios.get("http://localhost:5000/api/categories");
        setCategories(res.data);
      } catch (err) {
        console.error("Error fetching categories:", err);
      }
    };
    fetchCategories();
  }, []);

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
    <div className="home-container">
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
      <main className="hero">
        <div className="hero-left">
          <p className="hero-subtitle">New SS26 New Clothing</p>
          <h1 className="hero-title">
            Chic White Knit Top and Brown Jeans Set
          </h1>
          <button className="hero-btn">SHOP NOW</button>
        </div>
        <div className="hero-right">
          <img src={heroImg} alt="model" />
        </div>
      </main>
      <section className="categories">
        <h2>Categories</h2>
        <div className="categories-grid">
          {categories.map((cat) => (
            <Link
              to={`/category/${cat._id}`}
              key={cat._id}
              className="category-card"
            >
              <div className="small-circle">
                <img src={`/images/${cat.image}`} alt={cat.title} />
              </div>
              <h3 className="category-title">{cat.title}</h3>
            </Link>
          ))}
         </div>
        </section>
        <footer className="footer">
          <div className="footer-container">
            <div className="footer-section">
              <h3>LadyCham</h3>
              <p>
                LadyCham is a fashion destination <br/> dedicated to modern women. 
                Discover <br/> a curated collection of clothing, <br/> accessories, and stylish pieces 
                designed <br/> to bring elegance, confidence,<br/> and comfort to your everyday look.
              </p>
            </div>
            <div className="footer-section contact-section">
              <h4>Contact</h4>
              <p><FaEnvelope style={{ marginRight: "8px" }} /> Email: contact@ladycham.com</p>
              <p style={{ display: "flex", alignItems: "center", gap: "8px" }}>
                <FiPhone /> Phone: +216 12 345 678
              </p>
            </div>
            <div className="footer-section address-section">
              <h4>Address</h4>
              <p><FaMapMarkerAlt style={{ marginRight: "8px" }} /> Tunis, Tunisia</p>
              <p style={{ display: "flex", alignItems: "center", gap: "8px" }}>
                <FaClock /> Open: 9:00 - 18:00
              </p>
            </div>
            <div className="footer-section instagram">
              <h4>Follow Us</h4>
              <p><FaInstagram style={{ marginRight: "8px" }} /> Instagram</p>
              <p><FaFacebook style={{ marginRight: "8px" }} /> Facebook</p>
              <p><FaTiktok style={{ marginRight: "8px" }} /> TikTok</p>
            </div>
          </div>
          <div className="footer-bottom">
            © 2026 LadyCham - All Rights Reserved
          </div>
        </footer>
      </div>
    );
  };

export default Home;