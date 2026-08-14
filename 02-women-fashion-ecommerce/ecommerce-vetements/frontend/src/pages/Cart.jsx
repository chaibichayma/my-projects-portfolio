import React, { useEffect, useState } from "react";
import { useParams, Link, useNavigate } from "react-router-dom";
import axios from "axios";
import { FiTrash2, FiPlus, FiMinus, FiSearch, FiUser, FiHeart, FiBell, FiCheck, FiRefreshCw, FiPackage, FiSmile, FiPhone, FiShoppingCart } from "react-icons/fi";
import { FaEnvelope, FaPhone, FaMapMarkerAlt, FaInstagram, FaFacebook, FaTiktok, FaClock, FaStar, FaUser   } from 'react-icons/fa';
const Cart = () => {

const navigate = useNavigate();

const [products, setProducts] = useState([]);
const [quantities, setQuantities] = useState({});
const [likedProducts, setLikedProducts] = useState([]);
const [user, setUser] = useState(null);
const [showMenu, setShowMenu] = useState(false);
const [showCheckout, setShowCheckout] = useState(false);
const [successMessage, setSuccessMessage] = useState(""); 
const [checkoutData, setCheckoutData] = useState({
  name: "",
  surname: "",
  phone: "",
  email: "",
  address: "",
  region: "Region"
});

const handleChange = (e) => {
  setCheckoutData({ ...checkoutData, [e.target.name]: e.target.value });
};

const handleCheckout = async () => {
  if (!user) {
    alert("Please login first");
    navigate("/login");
    return;
  }

  const { name, surname, phone, email, address, region } = checkoutData;

  if (!name || !surname || !phone || !email || !address || !region) {
    alert("Please fill all fields");
    return;
  }

  try {
    for (const product of products) {
      await axios.post("http://localhost:5000/api/shop/create", {
        productId: product._id,
        name,
        surname,
        phone,
        email,
        address,
        region,
        total: (product.price * quantities[product._id]) + 8.5
      });
    }
    setShowCheckout(false);
    setSuccessMessage(`Congratulations ${name}! Your order has been successfully placed.`);
  } catch (error) {
    console.log(error);
    alert("Error during checkout");
  }
};

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

  useEffect(() => {
    const user = JSON.parse(localStorage.getItem("user"));
    if (!user || !user.cartProducts) return;
    axios.post(
      "http://localhost:5000/api/products/get-cart-products",
      { productIds: user.cartProducts }
    )
    .then(res => {
      setProducts(res.data);
      const initialQty = {};
      res.data.forEach(p => initialQty[p._id] = 1);
      setQuantities(initialQty);
    });
  }, []);

  const increaseQty = (id) => {
    setQuantities({ ...quantities, [id]: quantities[id] + 1 });
  };

  const decreaseQty = (id) => {
    if (quantities[id] > 1) {
      setQuantities({ ...quantities, [id]: quantities[id] - 1 });
    }
  };

  const removeProduct = async (productId) => {
    const confirmDelete = window.confirm("Do you want to remove this product from the cart?");
    if (!confirmDelete) return;
    try {
      const res = await axios.post(
        "http://localhost:5000/api/auth/remove-from-cart",
        {
          userId: user._id,
          productId: productId
        }
      );
      setProducts(products.filter(p => p._id !== productId));
      const updatedUser = {
        ...user,
        cartProducts: res.data.cartProducts
      };
      setUser(updatedUser);
      localStorage.setItem("user", JSON.stringify(updatedUser));
    } catch (error) {
      console.log(error);
    }
  };

  const total = products.reduce(
    (sum, p) => sum + p.price * quantities[p._id],
    0
  );

  return (
    <div className="cart-page">
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
    <h2 className="cart-title">My Cart Summary</h2>
    {successMessage && (
      <div className="success-message">
        {successMessage}
      </div>
    )}
    <div className="cart-layout">
      <div className="cart-items">
        {products.map(product => (
          <div key={product._id} className="cart-item">
            <img src={`/images/${product.images[0]}`} alt={product.title} />
            <div className="item-info">
              <h4>{product.title}</h4>
              <p className="product-price">{product.marque} </p>
            </div>
            <div className="quantity-box">
              <button onClick={() => decreaseQty(product._id)}>
                <FiMinus />
              </button>
              <span>{quantities[product._id]}</span>
              <button onClick={() => increaseQty(product._id)}>
                <FiPlus />
              </button>
            </div>
            <div className="item-total">
              {(product.price * quantities[product._id]).toFixed(2)} TND
            </div>
            <button
              className="delete-btn"
              onClick={() => removeProduct(product._id)}
            >
              <FiTrash2 />
            </button>
          </div>
        ))}
      </div>
      <div className="cart-summary">
        <h3>Products</h3>
        <p >{total.toFixed(2)} TND</p>
        <h3>Shipping</h3>
        <p>8.5 TND</p>
        <hr />
        <h2>Total</h2>
        <h2>{(total + 8.5).toFixed(2)} TND</h2>
        <button 
          className="checkout-btn"
          onClick={() => setShowCheckout(true)}
        >
          Place Order
        </button>
      </div>
    </div>
    <footer className="foooteer">
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
     {showCheckout && (
        <div className="checkout-modal">
          <div className="checkout-content">
            <span className="close-cross" onClick={() => setShowCheckout(false)}>
              ×
            </span>
            <h2 className="checkout-title">Complete Your Order</h2>
            <div className="checkout-summary">
              <div className="summary-row">
                <span>Subtotal</span>
                <span>{total.toFixed(2)} TND</span>
              </div>
              <div className="summary-row">
                <span>Shipping</span>
                <span>8.5 TND</span>
              </div>
              <div className="summary-total">
                <span>Total</span>
                <span>{(total + 8.5).toFixed(2)} TND</span>
              </div>
            </div>
            <div className="form-groupp">
              <FaUser className="input-icon"/>
              <input
                type="text"
                name="name"
                placeholder="First Name"
                value={checkoutData.name}
                onChange={handleChange}
              />
            </div>
            <div className="form-groupp">
              <FaUser className="input-icon"/>
              <input
                type="text"
                name="surname"
                placeholder="Last Name"
                value={checkoutData.surname}
                onChange={handleChange}
              />
            </div>
            <div className="form-groupp">
              <FiPhone className="input-icon"/>
              <input
                type="text"
                name="phone"
                placeholder="Phone"
                value={checkoutData.phone}
                onChange={handleChange}
              />
            </div>
            <div className="form-groupp">
              <FaEnvelope className="input-icon"/>
              <input
                type="email"
                name="email"
                placeholder="Email"
                value={checkoutData.email}
                onChange={handleChange}
              />
            </div> 
            <div className="form-groupp">
              <FaMapMarkerAlt className="input-icon"/>
              <input
                type="text"
                name="address"
                placeholder="Address"
                value={checkoutData.address}
                onChange={handleChange}
              />
            </div>
            <select
              className="region-select"
              name="region"
              value={checkoutData.region}
              onChange={handleChange}
            >
              <option>Select Region</option>
              <option>Tunis</option>
              <option>Sousse</option>
              <option>Sfax</option>
              <option>Mahdia</option>
            </select>
            <button className="confirm-btn" onClick={handleCheckout}>
              <FiShoppingCart /> BUY NOW - {(total + 8.5).toFixed(2)} TND
            </button>
          </div>
        </div>
      )}
    </div>
  );
};

export default Cart;