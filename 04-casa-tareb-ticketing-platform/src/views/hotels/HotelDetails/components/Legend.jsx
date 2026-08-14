import React from "react";
import "./legend.css";

const Legend = () => {
  return (
    <div className="zone-legend">
      <div className="zone-item">
        <div className="zone-square red"></div>
        <div className="zone-text">
          <div className="zone-title">ZONE CLEOPATRA</div>
          <div className="zone-price">50 DT</div>
        </div>
      </div>
      <div className="zone-item">
        <div className="zone-square jaune"></div>
        <div className="zone-text">
          <div className="zone-title">Fauteuille-jaune(5places)</div>
          <div className="zone-price">120 DT</div>
        </div>
      </div>
      

      <div className="zone-item">
        <div className="zone-square blue"></div>
        <div className="zone-text">
          <div className="zone-title">ZONE TANIT</div>
          <div className="zone-price">35 DT</div>
        </div>
      </div>
      <div className="zone-item">
        <div className="zone-square purple"></div>
        <div className="zone-text">
          <div className="zone-title">Fauteuille-purple(5places)</div>
          <div className="zone-price">140 DT</div>
        </div>
      </div>

      <div className="zone-item">
        <div className="zone-square green"></div>
        <div className="zone-text">
          <div className="zone-title">ZONE RAMSES</div>
          <div className="zone-price">25 DT</div>
        </div>
      </div>
      {/* 🟧 NOUVEAU : Réservé */}
      <div className="zone-item">
        <div className="zone-square orange"></div>
        <div className="zone-text">
          <div className="zone-title">Réservé</div>
        </div>
      </div>
    </div>
  );
};

export default Legend;
