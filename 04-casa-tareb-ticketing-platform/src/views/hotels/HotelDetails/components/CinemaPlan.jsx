import React, { useState, useEffect } from "react";
import "./CinemaPlan.css";
import planImage from "./plan.jpg";

const CinemaPlan = () => {
  const [selectedTable, setSelectedTable] = useState(null);
  const [selectedSeats, setSelectedSeats] = useState([]);
  const [zoom, setZoom] = useState(0.65); // 65%
  const zoomIn = () => {
  setZoom((prev) => Math.min(prev + 0.05, 1.5));
};

const zoomOut = () => {
  setZoom((prev) => Math.max(prev - 0.05, 0.4));
};

const resetZoom = () => {
  setZoom(0.65);
};


  const getSeatCount = (table) => {

    if (!isNaN(table) && Number(table) >= 52 && Number(table) <= 63) {
    return 5;
  }

  if (!isNaN(table) && Number(table) >= 81 && Number(table) <= 90) {
    return 5;
  }

    if (!isNaN(table) && Number(table) >= 34 && Number(table) <= 51) {
    return 10;
  }

  // 🎯 Salons 14 → 33 = 5 sièges
  if (!isNaN(table) && Number(table) >= 14 && Number(table) <= 33) {
    return 5;
  }

  // Tables 1 → 12 = 6 sièges
  if (!isNaN(table) && Number(table) >= 1 && Number(table) <= 12) {
    return 6;
  }

  // Tables 1B → 12B
  if (table.endsWith("B")) {
    if (table === "7B") return 6;
    return 4;
  }

  // Tables 1C → 11C
  if (table.endsWith("C")) {
    if (table === "1C" || table === "11C") return 2;
    if (table === "7C") return 4;
    return 6;
  }

  if (!isNaN(table) && Number(table) >= 64 && Number(table) <= 80) {
    if (table === "79" || table === "80") return 4;
    return 6;
  }



  

  return 6;
};


const getZoneAndPrice = (table) => {
  if (!isNaN(table) && Number(table) >= 34 && Number(table) <= 51) {
    return { zone: "ZONE TANIT", price: 100 };
  }
  // Salons 14 → 33
  if (!isNaN(table) && Number(table) >= 14 && Number(table) <= 33) {
    return { zone: "ZONE CLEOPATRA", price: 120 };
  }
  // Autres tables
  return { zone: "ZONE TANIT", price: 120 };
};




useEffect(() => {
  setSelectedSeats([]);
}, [selectedTable]);

const toggleSeat = (seatNumber) => {
  setSelectedSeats((prev) =>
    prev.includes(seatNumber)
      ? prev.filter((s) => s !== seatNumber)
      : [...prev, seatNumber]
  );
};

const isSalon =
  !isNaN(selectedTable) &&
  (
    (Number(selectedTable) >= 14 && Number(selectedTable) <= 63) ||
    (Number(selectedTable) >= 81 && Number(selectedTable) <= 90)
  );








  return (
    <div className="plan-wrapper">
  <div className="image-container">

    <div className="top-bar">

  {/* TARIFS */}
  <div className="tarifs-cards">
    <div className="tarif-card red-card">
      <span>CLEOPATRA</span>
      <strong>120 TND</strong>
    </div>

    <div className="tarif-card green-card">
      <span>RAMSES</span>
      <strong>80 TND</strong>
    </div>

    <div className="tarif-card blue-card">
      <span>TANIT</span>
      <strong>100 TND</strong>
    </div>
  </div>

  {/* ZOOM CONTROLS */}
  <div className="zoom-controls">
    <button onClick={zoomOut}>🔍−</button>
    <span>{Math.round(zoom * 100)}%</span>
    <button onClick={zoomIn}>🔍+</button>
    <button onClick={resetZoom}>↺</button>
  </div>

</div>


   <div className="zoom-wrapper"
  style={{
    transform: `scale(${zoom})`,
    transformOrigin: "top center"
  }}
>
  <img src={planImage} alt="Plan Salle" />

  {Object.keys(tablePositions).map((table) => {
    const isSalonCircle = !isNaN(table) && Number(table) >= 14 && Number(table) <= 33;
    const isBlueCircle = !isNaN(table) && Number(table) >= 34 && Number(table) <= 51;
    const isSalonCircleBleu = !isNaN(table) && Number(table) >= 52 && Number(table) <= 63;
    const isSalonGreen = !isNaN(table) && Number(table) >= 64 && Number(table) <= 80;
    const isSalonGreenn = !isNaN(table) && Number(table) >= 81 && Number(table) <= 90;

    return (
      <div
        key={table}
        className={`table-circle 
          ${isSalonCircle ? "salon-circle" : ""} 
          ${isBlueCircle ? "blue-circle" : ""} 
          ${isSalonCircleBleu ? "salon-circle-bleu" : ""} 
          ${isSalonGreen ? "green-circle" : ""}  
          ${isSalonGreenn ? "green-circlee" : ""}`}
        style={{
          top: tablePositions[table].top,
          left: tablePositions[table].left,
        }}
        onClick={() => setSelectedTable(table)}
      >
        {isSalonCircle && <div className="salon-icon">🛋</div>}
        {isSalonCircleBleu && <div className="salon-icon">🛋</div>}
        {isSalonGreenn && <div className="salon-icon">🛋</div>}

        {isBlueCircle && (
          <svg
            className="people-icon"
            xmlns="http://www.w3.org/2000/svg"
            width="12"
            height="12"
            viewBox="0 0 24 24"
            fill="white"
          >
            <path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5s-3 1.34-3 3 1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V19h6v-2.5c0-2.33-4.67-3.5-7-3.5z"/>
          </svg>
        )}

        {isSalonGreen && (
          <svg
            className="salon-icon-green"
            xmlns="http://www.w3.org/2000/svg"
            width="12"
            height="14"
            viewBox="0 0 24 24"
            fill="white"
          >
            <path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5s-3 1.34-3 3 1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V19h6v-2.5c0-2.33-4.67-3.5-7-3.5z"/>
          </svg>
        )}

        <span className={isBlueCircle ? "table-code-blue" : ""}>
          {table}
        </span>
      </div>
    );
  })}
</div>






      </div>

      {selectedTable && (
  <div className="popup-overlay" onClick={() => setSelectedTable(null)}>
    <div className="popup-card" onClick={(e) => e.stopPropagation()}>

      {/* HEADER */}
      <div className="popup-header">
        <div className="table-icon">🍽</div>
        <div>
          <h2 className="table-title">
  {isSalon ? "Salon" : "Table"} {selectedTable}
</h2>


          <p>
  {(!isNaN(selectedTable) && Number(selectedTable) >= 34 && Number(selectedTable) <= 63) 
    ? "ZONE TANIT • " + getSeatCount(selectedTable) + " places • 100 TND/place" 
    : (!isNaN(selectedTable) && Number(selectedTable) >= 64 && Number(selectedTable) <= 90)
      ? "ZONE RAMSES • " + getSeatCount(selectedTable) + " places • 80 TND/place"
      : "ZONE CLEOPATRA • " + getSeatCount(selectedTable) + " places • 120 TND/place"
  }
</p>


        </div>
        <button className="close-btn" onClick={() => setSelectedTable(null)}>✕</button>
      </div>

      <div className="scene-btn">↑ SCÈNE ↑</div>

      {/* TABLE VISUAL */}
      

<div className="table-visual">

  {isSalon ? (
    <>
      {[1, 2, 3, 4, 5].map((seat) => {
        const isSelected = selectedSeats.includes(seat);

        let positionClass = "";
        if (seat === 1) positionClass = "left-top";
        if (seat === 2) positionClass = "left-bottom";
        if (seat === 3) positionClass = "right-top";
        if (seat === 4) positionClass = "right-bottom";
        if (seat === 5) positionClass = "bottom-center";

        return (
          <div
            key={seat}
            className={`seat salon-seat ${positionClass} ${
              isSelected ? "selected" : ""
            }`}
            onClick={() => toggleSeat(seat)}
          >
            {seat}
          </div>
        );
      })}
    </>
  ) : (
    Array.from({ length: getSeatCount(selectedTable) }).map((_, index) => {
      const total = getSeatCount(selectedTable);
      const angle = (360 / total) * index;
      const radius = 110;
      const seatNumber = index + 1;
      const isSelected = selectedSeats.includes(seatNumber);

      return (
        <div
          key={index}
          className={`seat ${isSelected ? "selected" : ""}`}
          onClick={() => toggleSeat(seatNumber)}
          style={{
            transform: `
              rotate(${angle}deg)
              translate(${radius}px)
              rotate(-${angle}deg)
            `,
          }}
        >
          {seatNumber}
        </div>
      );
    })
  )}

  <div className="table-center">
    {selectedTable}
  </div>

</div>



      {/* STATS */}
      <div className="stats">
        <div className="stat total">
          <h3>{getSeatCount(selectedTable)}</h3>

          <span>Total</span>
        </div>
        <div className="stat free">
          <h3>{getSeatCount(selectedTable)}</h3>
          <span>Libres</span>
        </div>
        <div className="stat blocked">
          <h3>0</h3>
          <span>Bloquées</span>
        </div>
        <div className="stat sold">
          <h3>0</h3>
          <span>Vendues</span>
        </div>
      </div>
       
       {selectedSeats.length > 0 && (
  <div className="selection-bar">
    <div>
      <strong>{selectedSeats.length} place(s) sélectionnée(s)</strong>
      <br />
      Chaises : {selectedSeats.join(", ")}
    </div>

    <div className="price">
  {selectedSeats.length * 
  (
    (!isNaN(selectedTable) && Number(selectedTable) >= 34 && Number(selectedTable) <= 63) 
      ? 100 
      : (!isNaN(selectedTable) && Number(selectedTable) >= 64 && Number(selectedTable) <= 90)
        ? 80
        : 120
  )
} TND

</div>

  </div>
)}

      {/* ACTIONS */}
      <div className="actions">
        <button
  className="cancel"
  onClick={() => setSelectedTable(null)}
>
  Annuler
</button>

        <button className="buy">🛒 Acheter mon billet</button>
      </div>

    </div>
  </div>
)}

    </div>
  );
};

/* 🎯 Positions */
const tablePositions = {

  /* ===== LIGNE 1 → 12 ===== */
  1: { top: "17.5%", left: "25%" },
  2: { top: "18.5%", left: "29.2%" },
  3: { top: "20%", left: "33.5%" },
  4: { top: "21%", left: "38%" },
  5: { top: "21.2%", left: "42.5%" },
  6: { top: "22%", left: "47%" },
  7: { top: "22%", left: "51.5%" },
  8: { top: "21.5%", left: "55.8%" },
  9: { top: "21%", left: "60.2%" },
  10: { top: "20.3%", left: "64.8%" },
  11: { top: "19.6%", left: "69.1%" },
  12: { top: "18.9%", left: "73.1%" },

  /* ===== LIGNE 1B → 12B ===== */
  "1B": { top: "21.7%", left: "24.2%" },
  "2B": { top: "23%", left: "28.6%" },
  "3B": { top: "24.5%", left: "33.1%" },
  "4B": { top: "25.5%", left: "37.8%" },
  "5B": { top: "26%", left: "42.5%" },
  "6B": { top: "26.2%", left: "47%" },
  "7B": { top: "27.2%", left: "51.6%" },
  "8B": { top: "25.9%", left: "56.1%" },
  "9B": { top: "25.5%", left: "60.5%" },
  "10B": { top: "24.6%", left: "65.4%" },
  "11B": { top: "24%", left: "70%" },
  "12B": { top: "24.1%", left: "74.3%" },

  /* ===== LIGNE 1C → 11C ===== */
  "1C": { top: "25.3%", left: "23.7%" },
  "2C": { top: "27.5%", left: "27.8%" },
  "3C": { top: "29%", left: "32.6%" },
  "4C": { top: "30.5%", left: "37.5%" },
  "5C": { top: "30.9%", left: "42.2%" },
  "6C": { top: "31.2%", left: "46.9%" },
  "7C": { top: "31.8%", left: "51.6%" },
  "8C": { top: "31.1%", left: "56.4%" },
  "9C": { top: "30.4%", left: "60.7%" },
  "10C": { top: "29.5%", left: "65.9%" },
  "11C": { top: "27.5%", left: "70.4%" },


  14: { top: "32%", left: "21.5%" },
  15: { top: "33.9%", left: "27%" },
  16: { top: "35.3%", left: "33.3%" },
  17: { top: "36.5%", left: "39.5%" },
  18: { top: "36.7%", left: "45.4%" },
  19: { top: "36.7%", left: "55%" },
  20: { top: "36.5%", left: "61%" },
  21: { top: "35%", left: "67%" },
  22: { top: "34%", left: "73.1%" },
  23: { top: "31.3%", left: "79.1%" },

  
  24: { top: "39.4%", left: "20.5%" },
  25: { top: "42%", left: "26.7%" },
  26: { top: "43.8%", left: "32.6%" },
  27: { top: "45%", left: "38.7%" },
  28: { top: "45%", left: "44.5%" },
  29: { top: "45%", left: "55.5%" },
  30: { top: "44.8%", left: "62%" },
  31: { top: "43.5%", left: "67.8%" },
  32: { top: "42%", left: "74%" },
  33: { top: "39.2%", left: "79.4%" },

  34: { top: "48.5%", left: "15.1%" },
  35: { top: "50%", left: "18.8%" },
  36: { top: "51.4%", left: "22.5%" },
  37: { top: "53%", left: "26.2%" },
  38: { top: "54%", left: "30%" },
  39: { top: "55%", left: "33.9%" },
  40: { top: "55.2%", left: "37.8%" },
  41: { top: "55.7%", left: "41.8%" },
  42: { top: "56%", left: "45.7%" },
  43: { top: "56.4%", left: "55%" }, 
  44: { top: "56%", left: "59%" }, 
  45: { top: "55.5%", left: "63%" }, 
  46: { top: "54.2%", left: "67%" }, 
  47: { top: "53%", left: "71%" }, 
  48: { top: "52%", left: "75%" }, 
  49: { top: "50.2%", left: "79.3%" }, 
  50: { top: "49%", left: "83.3%" }, 
  51: { top: "47%", left: "87%" }, 

  /* ===== NOUVEAUX SALONS 52 → 63 (rouges) ===== */
52: { top: "54.5%", left: "13.5%" },
53: { top: "57%", left: "19.4%" },
54: { top: "59%", left: "25.3%" },
55: { top: "60.5%", left: "31.5%" },
56: { top: "62%", left: "38%" },
57: { top: "63%", left: "44.5%" },
58: { top: "62.5%", left: "56.3%" },
59: { top: "62%", left: "62.5%" },
60: { top: "61%", left: "68.8%" },
61: { top: "59.5%", left: "75%" },
62: { top: "57.8%", left: "81%" },
63: { top: "55%", left: "87.3%" },


  /* de 64 vers 80 */
64: { top: "64.5%", left: "13.7%" },
65: { top: "66.2%", left: "17.8%" },
66: { top: "68%", left: "21.8%" },
67: { top: "68.8%", left: "25.7%" },
68: { top: "70%", left: "29.7%" },
69: { top: "71%", left: "33.8%" },
70: { top: "71.5%", left: "37.7%" },
71: { top: "72%", left: "41.8%" },
72: { top: "72%", left: "45.6%" },
73: { top: "72.3%", left: "55.5%" },
74: { top: "72%", left: "59.5%" },
75: { top: "72%", left: "63.6%" },
76: { top: "71%", left: "67.5%" },
77: { top: "70%", left: "71.5%" },
78: { top: "69%", left: "75.5%" },
79: { top: "67.5%", left: "79.5%" },
80: { top: "65.5%", left: "83.5%" },

 /* de 81 vers 90 */
81: { top: "72.7%", left: "17.5%" },
82: { top: "74.5%", left: "24%" },
83: { top: "76.1%", left: "30%" },
84: { top: "77.5%", left: "36.5%" },
85: { top: "78%", left: "43%" },
86: { top: "78.5%", left: "57.5%" },
87: { top: "78%", left: "63.9%" },
88: { top: "77.1%", left: "70.3%" },
89: { top: "75.4%", left: "76.5%" },
90: { top: "73.5%", left: "82.8%" },



};

export default CinemaPlan;
