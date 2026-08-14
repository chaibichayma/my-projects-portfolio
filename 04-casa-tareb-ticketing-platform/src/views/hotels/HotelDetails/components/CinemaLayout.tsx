import BlueTablesRow from "./BlueTablesRow";
import GreenTablesRow from "./grenn_table";
import RedSeatsRow from "./RedSeatsRow";
import BlueSeats from "./BlueSeats";
import {  AlertCircle, Calendar, Clock } from "lucide-react";
import React, { useState, useRef, useEffect } from "react";
import RedTablesRow from "./CinemaSeats";
import VipTablesRow from "./VipTablesRow";
import PremiumTablesRow from "./PremiumTablesRow";
import "./CinemaLayout.css";
import GreenSeats from "./GreenSeats";
import { EventBean, PlaceBean, ZoneBean } from "../../../../states/stateModels";
import { URL_API_NAME } from '../../../../states/constants';



type PlanType =
  | "tables-cleopatra"
  | "salons-cleopatra"
  | "tables-tanit"
  | "salons-tanit"
  | "tables-ramses"
  | "salons-ramses"   // <-- nouveau
  | null;







  

const CinemaLayout: React.FC<{ event:EventBean }> = ({ event },) => {
  const [cartCount, setCartCount] = useState(0);
  const [commandeMessage, setCommandeMessage] = useState(false);
  const [openPlan, setOpenPlan] = useState<ZoneBean>(null!);
  // Ajouter un objet dynamique pour les zones


  const cinemaRef = useRef<HTMLDivElement>(null);

  const [zoneLists, setZoneLists] = useState<ZoneBean[]>([]);
  const [placeLists, setPlaceLists] = useState<PlaceBean[]>([]);

        useEffect(() => {
    fetch( URL_API_NAME+"/events/getEventZonePrices",{
        method: 'POST',
         headers: {
          'Content-Type': 'application/json'
          
        },
        body: '{"eventId":"'+event.id+'"}',
        
      })
      .then((res) => res.json())
      .then((data) => {
        setZoneLists(data);
      })
      .catch((err) => console.error("API error:", err));
  }, []);


  const getPlaceList = async (zoneBean:any) => {
    try {
      setOpenPlan(zoneBean);
       await fetch(URL_API_NAME+'/events/getEventPlaceStates', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
           
          },
          body: '{"eventId":"'+event.id+'","zoneId":"'+zoneBean.id+'"}',
          
        }).then((res) => res.json())
      .then((data) => {
       setPlaceLists(data);
      })
      
    } catch (error) {
    console.error("API error:", error)
    }
  };

  
  
  

  useEffect(() => {
    const el = cinemaRef.current;
    if (el) {
      const center = (el.scrollWidth - el.clientWidth) / 2;
      el.scrollLeft = center;
    }
  }, []);

  const handleCommande = () => {
    setCartCount((prev) => prev + 1);
    setCommandeMessage(true);
    setTimeout(() => setCommandeMessage(false), 2500);
  };

  

  return (
    <>
      {/* 🔔 ALERTE PANIER */}
      {commandeMessage && (
        <div className="commande-alert-top">
          <AlertCircle size={24} className="alert-icon" />
          <div className="alert-text">
            <div className="alert-title">Panier</div>
            <div className="alert-message">
              Place ajoutée avec succès !
            </div>
          </div>
        </div>
      )}

      {/* =====================
          LISTE DES BILLETS
      ====================== */}
      <div className="tickets-container">

  <div className="tickets-header">
    - BILLETS -
  </div>
     <div className="tickets-list">

  {/* TABLES CLÉOPÂTRE */}


  {
            (zoneLists.map((zone, idx) => {
            return <div className="ticket-row" key={idx}>
    <div className="ticket-left">
      <div className="ticket-meta">
        <span className="meta-item">
          <Calendar size={16} className="meta-icon" />
          <span>{event.eventDay}</span>
        </span>
        <span className="meta-item">
          <Clock size={16} className="meta-icon" />
          <span>{event.eventHour}</span>
        </span>
      </div>

      <div className="ticket-info">
        <span className="ticket-title">{zone.title}</span>
        <span className="ticket-price">
  <span className="price-amount">{zone.price}</span>
  <span className="price-currency">TND</span>
</span>


      </div>
    </div>

    <button onClick={() => getPlaceList(zone)}>Plan</button>
  </div>;
          }))}

  
</div>

</div>





      {/* =====================
          POPUP PLAN
      ====================== */}
     {openPlan && (
  <div className="plan-overlay" onClick={() => setOpenPlan(null!)}>
    <div className="plan-modal" onClick={(e) => e.stopPropagation()}>
      {/* Bouton fermer */}
      <button className="close-btn" onClick={() => setOpenPlan(null!)}>✕</button>

      {/* Header avec titre et nombre de places */}
      <div className="plan-header-section">
  {/* Titre principal en haut */}
  {/* Texte au-dessus de la ligne grise */}
<div className="plan-header-title">
  Teatro Cléopatra Gammarth
</div>


  <div className="plan-divider" /> {/* ligne grise */}

  {/* Texte sous la ligne grise */}
  <div className="plan-header-subtitle">
    Sélectionnez vos places
  </div>

  {/* Ligne avec places disponibles + titre à gauche */}
  <div className="plan-available-row">
  <span className="plan-available-title">{openPlan.title}</span>
  <span className="separator"> - </span> {/* <-- le tiret */}
  <span className="plan-available-count">
    {openPlan.available} places libres
  </span>
</div>

</div>




      {/* Contenu des tables / sièges */}
      {/* Contenu des tables / sièges */}
{/* Contenu des tables / sièges */}
{/* Contenu des tables / sièges */}
<div className="plan-content">

  {/* Tables / sièges scrollable */}
  {openPlan.keyname === "tables-cleopatra" && (
    <div className="tables-wrapper">
      <div className="tables-inner">
         <PremiumTablesRow onCommande={handleCommande} price={openPlan.price} event={event} statePlaces={placeLists}/>
        <VipTablesRow onCommande={handleCommande} price={openPlan.price} event={event}  statePlaces={placeLists}/>
        <RedTablesRow 
    onCommande={handleCommande} 
    price={openPlan.price} 
    event={event}  
    statePlaces={placeLists} // <-- ici
/>

      </div>
    </div>
  )}
  {openPlan.keyname === "salons-cleopatra" && (
    <div className="tables-wrapper">
      <div className="tables-inner">
        <RedSeatsRow onCommande={handleCommande} price={openPlan.price} event={event}  statePlaces={placeLists} />
      </div>
    </div>
  )}
  {openPlan.keyname === "tables-tanit" && (
    <div className="tables-wrapper">
      <div className="tables-inner">
        <BlueTablesRow onCommande={handleCommande} price={openPlan.price} event={event}  statePlaces={placeLists} />
      </div>
    </div>
  )}
  {openPlan.keyname === "salons-tanit" && (
    <div className="tables-wrapper">
      <div className="tables-inner">
        <BlueSeats onCommande={handleCommande} price={openPlan.price} event={event}  statePlaces={placeLists} />
      </div>
    </div>
  )}
  {openPlan.keyname === "tables-ramses" && (
    <div className="tables-wrapper">
      <div className="tables-inner">
        <GreenTablesRow onCommande={handleCommande} price={openPlan.price} event={event}  statePlaces={placeLists}/>
      </div>
    </div>
  )}
  {openPlan.keyname === "salons-ramses" && (
  <div className="tables-wrapper">
    <div className="tables-inner">
      <GreenSeats onCommande={handleCommande} price={openPlan.price} event={event}  statePlaces={placeLists}/>
    </div>
  </div>
)}


  {/* ===================== */}
  {/* LEGENDE DES COULEURS – AU DESSOUS DES TABLES */}
  <div className="plan-legend">
   
    {/* ===================== */}
{/* LEGENDE DES COULEURS – AU DESSOUS DES TABLES */}
<div className="plan-legend">
  <div className="legend-item">
    <div
      className={`legend-square ${
        openPlan.keyname === "salons-cleopatra"
          ? "legend-red"
          : openPlan.keyname === "salons-tanit"
          ? "legend-blue"
          : openPlan.keyname === "salons-ramses"
          ? "legend-green"
          : "legend-grey"
      }`}
    ></div>
    <span>Places libres</span>
  </div>
  <div className="legend-item">
    <div className="legend-square legend-orange"></div>
    <span>Mes places</span>
  </div>
</div>

  </div>

</div>



    </div>
  </div>
)}



    </>
  );
};

export default CinemaLayout;