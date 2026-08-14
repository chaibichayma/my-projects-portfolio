import React, { useEffect, useState } from "react";
import { useParams, Link, useNavigate } from "react-router-dom";
import axios from "axios";
import "./Home.css";
import { FiSearch, FiUser, FiHeart, FiBell, FiCheck, FiRefreshCw, FiPackage, FiSmile, FiPhone, FiShoppingCart } from "react-icons/fi";
import { FaEnvelope, FaPhone, FaMapMarkerAlt, FaInstagram, FaFacebook, FaTiktok, FaClock, FaStar   } from 'react-icons/fa';

const ProductDetails = () => {
  const { id } = useParams();
  const navigate = useNavigate();
  const [product, setProduct] = useState(null);
  const [loading, setLoading] = useState(true);
  const [showFullDescription, setShowFullDescription] = useState(false);
  const [user, setUser] = useState(null);
  const [showMenu, setShowMenu] = useState(false);
  const [likedProducts, setLikedProducts] = useState([]);
 const [comments, setComments] = useState([]);
  const addToCart = async () => {

  if (!user) {
    alert("Please login first");
    navigate("/login");
    return;
  }
  try {
    const res = await axios.post(
      "http://localhost:5000/api/auth/add-to-cart",
      {
        userId: user._id,
        productId: product._id
      }
    );
    const updatedUser = {
      ...user,
      cartProducts: res.data.cartProducts
    };
    setUser(updatedUser);
    localStorage.setItem("user", JSON.stringify(updatedUser));
    alert("Product added to cart");
  } catch (error) {
    console.log(error);
  }
};

  useEffect(() => {
    const fetchProduct = async () => {
      try {
        const res = await axios.get(`http://localhost:5000/api/products/${id}`);
        setProduct(res.data);
        setLoading(false);
      } catch (err) {
        console.log(err);
        setLoading(false);
      }
    };
    fetchProduct();
  }, [id]);
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

function stringToColor(str) {
  let hash = 0;
  for (let i = 0; i < str.length; i++) {
    hash = str.charCodeAt(i) + ((hash << 5) - hash);
  }
  let color = "#";
  for (let i = 0; i < 3; i++) {
    const value = (hash >> (i * 8)) & 0xff;
    color += ("00" + value.toString(16)).substr(-2);
  }
  return color;
}

function handleLikeComment(id) {
  setComments((prev) =>
    prev.map((c) =>
      c._id === id ? { ...c, likes: (c.likes || 0) + 1 } : c
    )
  );
}

 useEffect(() => {
  const fetchComments = async () => {
    try {
      const res = await axios.get(`http://localhost:5000/api/products/${id}/comments`);
      setComments(res.data);
    } catch (err) {
      console.log(err);
    }
  };
  fetchComments();
}, [id]);

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
  if (loading) return <p className="loading">Loading...</p>;
  if (!product) return <p className="loading">Produit introuvable</p>;

  return (
    <div className="product-page">
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
            <button
              className={`icon-button heart-nav ${likedProducts.length > 0 ? "active" : ""}`}
              onClick={() => navigate("/liked")}
            >
              <FiHeart className="icon" />
                {likedProducts.length > 0 && (
                  <span className="badge">{likedProducts.length}</span>
                )}
            </button>
            <button className="icon-button"><FiBell className="icon"><span className="badge"></span></FiBell></button>
          </div>
        </header>
        <div className="topbaar">
          <div className="topbar-left">
            <span className="menu-icon">☰</span>
            <span>All Categories</span>
          </div>
          <div className="topbar-center">
            <a href="#">Dress</a>
            <a href="#">Shoes</a>
            <a href="#">Sweaters</a>
            <a href="#">Accessories</a>
            <a href="#">Jeans</a>
            <a href="#">Bags</a>
            <a href="#">Makeup</a>
            <a href="#">Perfume</a>
          </div>
        </div>
        <div className="product-main">
          <div className="left-side">
            <img src={`/images/${product.images[0]}`} alt={product.title} className="main-image" />
            <div className="thumbnail-gallery">
              {product.images.slice(1, 4).map((img, index) => (
                <img
                  key={index}
                  src={`/images/${img}`}
                  alt={`${product.title} ${index + 1}`}
                  className="thumbnail"
                  onClick={() => {
                    const newImages = [...product.images];
                    [newImages[0], newImages[index + 1]] = [newImages[index + 1], newImages[0]];
                    setProduct({ ...product, images: newImages });
                  }}
                />
              ))}
            </div>
          </div>
          <div className="right-side">
            <div className="rating">
              <FaStar /><FaStar /><FaStar /><FaStar /><FaStar />
              <span>51 reviews</span>
            </div>
            <h1>{product.title}</h1>
            <p className="description">
              {showFullDescription
                ? product.description
                : product.description.slice(0, 200) + "..."}
            </p>
            {product.description.length > 200 && (
              <div
                className="show-more-link"
                onClick={() => setShowFullDescription(!showFullDescription)}
              >
              {showFullDescription ? "Voir moins" : "En savoir plus"}
            </div>
          )}
          <p className="price">
            {product.offerStart &&
              product.offerEnd &&
              product.discountPrice &&
              new Date() >= new Date(product.offerStart) &&
              new Date() <= new Date(product.offerEnd)
                ? `${product.discountPrice} TND`
                : `${product.price} TND`}
          </p>
          <div className="buttons">
            <button className="cart" onClick={addToCart}>
              Add to Cart
            </button>
            <button className="buy">Order Now</button>
          </div>
        </div>
      </div>
      <div className="product-benefits">
        <div className="benefit">
          <FiCheck className="benefit-icon" />
          <span>Exchange possible within 48 hours after delivery</span>
        </div>
        <div className="benefit">
          <FiRefreshCw className="benefit-icon" />
          <span>Receive a gift for any purchase over 300 TND</span>
        </div>
        <div className="benefit">
          <FiPackage className="benefit-icon" />
          <span>Free shipping for orders over 300 TND</span>
        </div>
        <div className="benefit">
          <FiSmile className="benefit-icon" />
          <span>24/7 Support</span>
        </div>
      </div>
      <div className="product-comments-wrapper">
        <div className="product-comments">
          <h2>Reviews</h2>
          {user ? (
            <form
              className="comment-form-pro"
              onSubmit={async (e) => {
                e.preventDefault();
                const commentText = e.target.comment.value.trim();
                if (!commentText) return;
                try {
                  await axios.post(
                    `http://localhost:5000/api/products/${product._id}/comment`,
                    { userId: user._id, text: commentText }
                  );
                  const newComment = {
                    _id: Date.now(),
                    userName: user.name,
                    text: commentText,
                    createdAt: new Date(),
                    likes: 0
                  };
                  setComments([newComment, ...comments]);
                  e.target.reset();
                } catch (err) {
                  console.log(err);
                  alert("Comment added successfully");
                }
              }}
            >
            <textarea
              name="comment"
              placeholder="Write a comment…"
              rows="3"
              required
            ></textarea>
            <button type="submit" className="submit-btn-pro">Send</button>
          </form>
          ) : (
            <p className="login-prompt-pro">
              <Link to="/login">Log in</Link> to write a comment
            </p>
          )}
          <div className="comments-list-pro">
            {comments.length === 0 && <p className="no-comments-pro">No comments yet.</p>}
            {comments.map((c) => (
              <div key={c._id} className="comment-card-pro">
                <div className="comment-top">
                  <div
                    className="avatar-pro"
                    style={{ backgroundColor: stringToColor(c.userName) }}
                  >
                    {c.userName.charAt(0).toUpperCase()}
                  </div>
                  <div className="comment-meta-pro">
                    <strong>{c.userName}</strong>
                    <span>{new Date(c.createdAt).toLocaleString()}</span>
                  </div>
                </div>
                <p className="comment-text-pro">{c.text}</p>
                <div className="comment-actions-pro">
                  <button
                    className="like-btn"
                    onClick={() => handleLikeComment(c._id)}
                  >
                    ❤️ {c.likes || 0}
                  </button>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
      <footer className="footeeer">
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

export default ProductDetails;