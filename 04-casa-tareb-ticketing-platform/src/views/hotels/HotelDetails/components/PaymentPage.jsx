import { Card, CardBody, Col, Container, Dropdown, DropdownItem, DropdownMenu, DropdownToggle, Image, Row } from 'react-bootstrap';
import { BsCalendar, BsCurrencyDollar, BsFilePdf, BsPeople, BsPerson, BsShare, BsVr, BsWallet2 } from 'react-icons/bs';
import { FaCopy, FaLinkedin } from 'react-icons/fa6';
import { FaFacebookSquare, FaTwitterSquare } from 'react-icons/fa';
import { useEffect, useState } from "react";
import mm10 from "@/assets/images/capo.png";
import { Link, useNavigate } from 'react-router-dom';

const PaymentPage = () => {
  const [timeLeft, setTimeLeft] = useState(7 * 60 + 18);
  const [emailEnabled, setEmailEnabled] = useState(true);
  const [email, setEmail] = useState("");
  const [cardNumber, setCardNumber] = useState("");
  const [securityCode, setSecurityCode] = useState("");
  const navigate = useNavigate();
  const [error, setError] = useState("");

  const handleValider = () => {
  const isValid = handleValideer();

  if (!isValid) return;

  navigate("/evenement-confirmed");
};


  

  const handleValideer = () => {
  if (
    cardNumber.trim() === "" ||
    securityCode.trim() === "" ||
    (emailEnabled && email.trim() === "")
  ) {
    setError("Veuillez remplir tous les champs");
    return false;
  }

  setError("");
  return true;
};





  useEffect(() => {
    const timer = setInterval(() => {
      setTimeLeft((prev) => (prev > 0 ? prev - 1 : 0));
    }, 1000);

    return () => clearInterval(timer);
  }, []);

  const minutes = Math.floor(timeLeft / 60);
  const seconds = timeLeft % 60;

  // Styles intégrés
  const styles = {
    paymentContainer: {
      minHeight: "100vh",
      backgroundColor: "#ffffff",
      display: "flex",
      justifyContent: "center",
      alignItems: "center",
    },
    paymentCard: {
      width: "480px",
      background: "#fff",
      padding: "35px",
      borderRadius: "6px",
      boxShadow: "0 10px 30px rgba(0, 0, 0, 0.1)",
    },
    paymentLogo: {
      textAlign: "center",
      marginBottom: "25px",
    },
    paymentCardTitle: {
      fontSize: "20px",
      marginBottom: "5px",
      color: "#000",
    },
    orderNumber: {
      fontWeight: 600,
      marginBottom: "10px",
      color: "#000",
    },
    timer: {
      fontSize: "14px",
      marginBottom: "25px",
      color: "#000",
    },
    timerStrong: {
      color: "#000",
      fontWeight: 700,
    },
    formGroup: {
      marginBottom: "15px",
    },
    input: {
      width: "100%",
      padding: "12px",
      borderRadius: "4px",
      border: "1px solid #ccc",
      fontSize: "14px",
      backgroundColor: "#ffffff",
      color: "#000000",
    },
    row: {
      display: "flex",
      gap: "10px",
      marginBottom: "15px",
    },
    emailCheck: {
      display: "flex",
      alignItems: "center",
      gap: "8px",
      marginBottom: "10px",
      fontSize: "14px",
      color: "#000",
    },
    payBtn: {
      width: "100%",
      padding: "14px",
      backgroundColor: "#FFD700",
      color: "#000",
      border: "none",
      borderRadius: "4px",
      fontSize: "16px",
      fontWeight: "bold",
      cursor: "pointer",
    },
  };

  return (
    <div style={styles.paymentContainer}>
      <div style={styles.paymentCard}>
        {/* LOGO */}
        <div style={styles.paymentLogo}>
          <img src={mm10} alt="Paiement" style={{ height: 55, width: 200 }} />
        </div>

        {/* ORDER */}
        <h2 style={styles.paymentCardTitle}>Numéro de la commande</h2>
        <p style={styles.orderNumber}>05454878</p>

        {/* TIMER */}
        <p style={styles.timer}>
          Il reste jusqu'à la fin de la session{" "}
          <strong style={styles.timerStrong}>
            {minutes.toString().padStart(2, "0")} min.{" "}
            {seconds.toString().padStart(2, "0")} sec.
          </strong>
        </p>

        {/* FORM */}
        <div style={styles.formGroup}>
          <input
  type="text"
  placeholder="Numéro de la carte"
  value={cardNumber}
  onChange={(e) => setCardNumber(e.target.value)}
  autoComplete="off"
  name="card-number"
  style={styles.input}
/>

        </div>

        <div style={styles.row}>
          <select style={styles.input}>
            <option>Mois</option>
            {Array.from({ length: 12 }, (_, i) => (
              <option key={i}>{(i + 1).toString().padStart(2, "0")}</option>
            ))}
          </select>

          <select style={styles.input}>
            <option>Année</option>
            {Array.from({ length: 10 }, (_, i) => (
              <option key={i}>{2025 + i}</option>
            ))}
          </select>

          <input
  type="password"
  placeholder="Code de sûreté"
  value={securityCode}
  onChange={(e) => setSecurityCode(e.target.value)}
  autoComplete="new-password"
  name="security-code"
  style={styles.input}
/>

        </div>

        <div style={styles.formGroup}>
          <input type="text" placeholder="Le nom du détenteur" style={styles.input} />
        </div>

        {/* EMAIL CHECK */}
        <div style={styles.emailCheck}>
          <input
            type="checkbox"
            checked={emailEnabled}
            onChange={() => setEmailEnabled(!emailEnabled)}
          />
          <label>
            Adresse e-mail {emailEnabled ? "(notification activée)" : "(notification désactivée)"}
          </label>
        </div>

        {/* EMAIL INPUT */}
        <div style={styles.formGroup}>
          <input
            type="email"
            placeholder="exemple@email.com"
            value={emailEnabled ? email : "Notification désactivée"}
            disabled={!emailEnabled}
            onChange={(e) => setEmail(e.target.value)}
            style={styles.input}
          />
        </div>
        {error && (
  <p style={{ color: "red", fontSize: "14px", marginBottom: "10px" }}>
    {error}
  </p>
)}


        {/* BUTTON */}
        <button
  style={styles.payBtn}
  onClick={handleValider}
>
  Paiement 54254 TND
</button>

      </div>
    </div>
  );
};
export default PaymentPage;
