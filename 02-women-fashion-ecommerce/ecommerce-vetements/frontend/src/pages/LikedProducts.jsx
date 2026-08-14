import React, { useEffect, useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import axios from "axios";
import { FcGoogle } from "react-icons/fc";
import { FiHeart, FiSearch, FiUser, FiBell, FiPhone  } from "react-icons/fi";
import { FaFacebookF, FaEnvelope, FaMapMarkerAlt, FaInstagram, FaFacebook, FaTiktok, FaClock } from "react-icons/fa";
import "./Home.css"; 

const LikedProducts = () => {
  const [products, setProducts] = useState([]);
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [user, setUser] = useState(null);
  const [showMenu, setShowMenu] = useState(false);
  const navigate = useNavigate();

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

    useEffect(() => {
      const savedUser = localStorage.getItem("user");
      if (!savedUser) return;
      const user = JSON.parse(savedUser);
      if (!user.likedProducts || user.likedProducts.length === 0) return;
      axios
        .post("http://localhost:5000/api/products/get-liked", {
          productIds: user.likedProducts
        })
        .then(res => setProducts(res.data))
        .catch(err => console.log(err));
    }, []);

    if (products.length === 0)
      return (
        <div className="liked-empty">
          <h2>❤️ No liked products yet</h2>
          <p>Browse our catalog and add your favorite products.</p>
        </div>
      );
    return (
      <div className="liked-page">
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
            <button className="icon-button"><FiBell className="icon"><span className="badge"></span></FiBell></button>
          </div>
          </header>
            <h2 className="liked-title">💖 My Liked Products</h2>
            <div className="liked-products-grid">
              {products.map(p => (
                <Link key={p._id} to={`/product/${p._id}`} className="liked-product-card">
                  <div className="liked-product-image">
                    <img src={`/images/${p.images[0]}`} alt={p.title} />
                    <span className="heart-badge">
                      <FiHeart className="heart-icon" />
                    </span>
                  </div>
                  <div className="liked-product-info">
                    <h3>{p.title}</h3>
                    <p className="liked-product-brand">{p.marque}</p>
                    <p className="liked-product-price">{p.price} TND</p>
                  </div>
                </Link>
              ))}
            </div>
            <footer className="footeeeer">
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

export default LikedProducts;