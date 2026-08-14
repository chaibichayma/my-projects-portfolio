import React, { useEffect, useState } from "react";
import { useParams, Link, useNavigate } from "react-router-dom";
import axios from "axios";
import "./Home.css";
import { FiSearch, FiUser, FiHeart, FiBell, FiPhone, FiFilter,  FiShoppingCart } from "react-icons/fi";
import { FaEnvelope, FaPhone, FaMapMarkerAlt, FaInstagram, FaFacebook, FaTiktok, FaClock  } from 'react-icons/fa';

const CategoryProducts = () => {
  const { id } = useParams();
  const navigate = useNavigate();
  const [products, setProducts] = useState([]);
  const [now, setNow] = useState(Date.now());
  const [likedProducts, setLikedProducts] = useState([]);
  const [category, setCategory] = useState(null);
  const [selectedBrand, setSelectedBrand] = useState("");
  const [priceRange, setPriceRange] = useState("");
  const [discountOnly, setDiscountOnly] = useState(false);
  const brands = ["All", ...new Set(products.map(p => p.marque))];
  const [sortOption, setSortOption] = useState("newest");
  const [user, setUser] = useState(null);
  const [showMenu, setShowMenu] = useState(false);

  useEffect(() => {

  const savedUser = localStorage.getItem("user");

  if (savedUser) {

    const parsedUser = JSON.parse(savedUser);

    setUser(parsedUser);

    if (parsedUser.likedProducts) {
      setLikedProducts(parsedUser.likedProducts.map(id => id.toString()));
    }

  }

}, []);

const toggleLike = async (productId) => {
  if (!user) {
    alert("Please login first");
    navigate("/login");
    return;
  }
  try {
    const res = await axios.post(
      "http://localhost:5000/api/auth/like-product",
      {
        userId: user._id,
        productId: productId
      }
    );
    const likedIds = res.data.likedProducts.map(id => id.toString());
    setLikedProducts(likedIds);
    const updatedUser = {
      ...user,
      likedProducts: likedIds
    };
    setUser(updatedUser);
    localStorage.setItem("user", JSON.stringify(updatedUser));
  } catch (error) {
    console.log(error);
  }
};

useEffect(() => {
  axios
    .get(`http://localhost:5000/api/products/category/${id}`)
    .then((res) => setProducts(res.data))
    .catch((err) => console.log(err));

}, [id]);

const handleLogout = () => {
  const confirmLogout = window.confirm(
    "Do you really want to log out?"
  );
  if (confirmLogout) {
    localStorage.removeItem("user");
    setUser(null);
    navigate("/login");
  }
};

return (

  <div>
    <header className="navbar">
      <div className="navbar-left">
        <div className="logo">LadyCham</div>
          <Link to="/" className="nav-link">Home</Link>
          <Link to="/" className="nav-link">Promotion</Link>
          <Link to="/contact" className="nav-link">Contact</Link>
          {!user && <Link to="/login" className="nav-link">Login</Link>}
          {!user && <Link to="/signup" className="nav-link">Sign Up</Link>}
        </div>
        <div className="navbar-right">
          <button className="icon-button">
            <FiSearch className="icon" />
          </button>
          <button className="icon-button" onClick={() => navigate("/cart")}>
            <FiShoppingCart className="icon" />
            {user?.cartProducts?.length > 0 && (
              <span className="badge">{user.cartProducts.length}</span>
            )}
          </button>
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
                  <Link to="/login">Login</Link>
                ) : (
                <>
                  <p className="user-name">Hello {user.name}</p>
                  <Link to="/reviews">My Reviews</Link>
                  <hr className="dropdown-divider" />
                  <Link to="/orders">My Orders</Link>
                  <hr className="dropdown-divider" />
                  <button
                    className="logout-btn"
                    onClick={handleLogout}
                  >
                    Log out
                  </button>
               </>
              )}
            </div>
          )}
        </div>
      <button
        className={`icon-button heart-nav ${likedProducts.length > 0 ? "active" : ""}`}
        onClick={() => navigate("/liked")}
      >
        <FiHeart className="icon" />
        {likedProducts.length > 0 && (
          <span className="badge">{likedProducts.length}</span>
        )}
      </button>
      <button className="icon-button">
        <FiBell className="icon" />
      </button>
    </div>
    </header>
      <div className="topbar">
        <div className="topbar-left">
          <span className="menu-icon">☰</span>
          <span>All Categories</span>
        </div>
        <div className="topbar-center">
          <a href="#">Dress</a>
          <a href="#">Shoes</a>
          <a href="#">Sweaters</a>
          <a href="#">Accessoires</a>
          <a href="#">Jeans</a>
          <a href="#">Bags</a>
          <a href="#">Makeup</a>
          <a href="#">Perfume</a>
        </div>
      </div>
      <div className="products-container">
        <div className="filters-sidebar">
          <h3 className="filters-title">
          <FiFilter className="filter-icon" />
            Filters
          </h3>
          <div className="filter-block">
            {brands.map((brand) => (
              <label key={brand}>
              <input
                type="checkbox"
                checked={brand === "All" ? selectedBrand === "" : selectedBrand === brand}
                onChange={() =>
                  setSelectedBrand(
                    brand === "All"
                    ? ""
                    : selectedBrand === brand
                    ? ""
                    : brand
                  )
                }
              />
              {brand}
            </label>
          ))}
        </div>
        <div className="filter-block">
          <p>Price</p>
          <label>
            <input
              type="checkbox"
              checked={priceRange === "0-1000"}
              onChange={() =>
                setPriceRange(priceRange === "0-1000" ? "" : "0-1000")
              }
            />
            0 - 1000 TND
          </label>
          <label>
            <input
              type="checkbox"
              checked={priceRange === "1000-2000"}
              onChange={() =>
                setPriceRange(priceRange === "1000-2000" ? "" : "1000-2000")
              }
            />
            1000 - 2000 TND
          </label>
          <label>
            <input
              type="checkbox"
              checked={priceRange === "2000+"}
              onChange={() =>
                setPriceRange(priceRange === "2000+" ? "" : "2000+")
              }
            />
            2000+ TND
          </label>
        </div>
        <div className="filter-block">
          <label>
            <input
              type="checkbox"
              checked={discountOnly}
              onChange={() => setDiscountOnly(!discountOnly)}
            />
            Discount products
          </label>
        </div>
      </div>
      <div className="products-grid">
        {products
          .filter((p) => {
            if (selectedBrand && p.marque !== selectedBrand) {
              return false;
            }
            if (priceRange === "0-1000" && p.price > 1000) {
              return false;
            }
            if (priceRange === "1000-2000" && (p.price < 1000 || p.price > 2000)) {
              return false;
            }
            if (priceRange === "2000+" && p.price < 2000) {
              return false;
            }
            if (discountOnly && !p.discountPrice) {
              return false;
            }
            return true;
          })
          .sort((a, b) => {
            if (sortOption === "low") {
              return a.price - b.price;
            }
            if (sortOption === "high") {
              return b.price - a.price;
            }
            if (sortOption === "newest") {
              return new Date(b.createdAt) - new Date(a.createdAt);
            }
            return 0;
          })
          .map((p) => {
            const offerStartUTC = p.offerStart ? new Date(p.offerStart).getTime() : 0;
            const offerEndUTC = p.offerEnd ? new Date(p.offerEnd).getTime() : 0;
            const isOfferActive =
            p.discountPrice &&
            now >= offerStartUTC &&
            now <= offerEndUTC;
            return (
              <Link to={`/product/${p._id}`} className="product-link">
                <div className="product-card-horizontal">
                <FiHeart
                  className={`heart-icon ${likedProducts.includes(p._id) ? "liked" : ""}`}
                  onClick={(e) => {
                    e.preventDefault();
                    e.stopPropagation();
                    toggleLike(p._id);
                  }}
                />
                <div className="product-image-container">
                  {isOfferActive && (
                    <div className="discount-badge">
                      -{p.discountPercent}%
                    </div>
                  )}
                  <img
                    src={`/images/${p.images[0]}`}
                    alt={p.title}
                    className="product-image"
                  />
                </div>
                <div className="product-info">
                  <h3 className="product-title">{p.title}</h3>
                  {p.marque && (
                    <p className="product-brand">{p.marque}</p>
                  )}
                  {isOfferActive ? (
                    <>
                      <div className="price-row">
                        <span className="new-price">{p.discountPrice} TND</span>
                      </div>
                      <p className="old-price-line">
                        Original Price : <span>{p.price} TND</span>
                      </p>
                    </>
                  ) : (
                    <div className="price-row">
                      <span className="normal-price">{p.price} TND</span>
                    </div>
                  )}
                  <p className="shipping">
                    {p.shippingPrice > 0
                      ? `${p.shippingPrice} TND shipping fee`
                      : "Free shipping"}
                  </p>
                </div>
              </div>
              </Link>
            );
          })}
        </div>
      </div>
      <footer className="footeer">
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

export default CategoryProducts;