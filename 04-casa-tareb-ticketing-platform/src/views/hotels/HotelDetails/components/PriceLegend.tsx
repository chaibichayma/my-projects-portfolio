import React from "react";
import "./PriceLegend.css";
const PriceLegend = () => {
  const prices = [
    { color: "#c71f1f", label: "ZONE CLEOPATRA", price: "79 €" },
    { color: "#1e88e5", label: "ZONE TANIT", price: "69 €" },
    { color: "#0a8f08", label: "ZONE RAMSES", price: "59 €" },
    { color: "#ffa500", label: "Réservé" },
  ];

  return (
    <div className="price-legend">
      {/* Titre */}
    <div className="price-legend-title">
      TYPES DE BILLETS
    </div>
      {prices.map((item, index) => (
        <div className="price-row" key={index}>
          <div className="price-left">
            <span className="dot-box">
  <span
    className="price-dot"
    style={{ backgroundColor: item.color }}
  ></span>
</span>

            <div className="price-text">
              <div className="price-title">{item.label}</div>
              <div className="price-subtitle">{item.price}</div>

            </div>
          </div>

        </div>
      ))}
    </div>
  );
};

export default PriceLegend;

