import { Col, Container, Row } from 'react-bootstrap';
import HotelGridCard from './HotelGridCard';
import { useEffect,useState } from 'react';
import { URL_API_NAME } from '../../../../states/constants';
const HotelGridLayout = () => {
const [events, setEvents] = useState([]);
      useEffect(() => {
  fetch(URL_API_NAME+ "/events/getEventList")
    .then((res) => res.json())
    .then((data) => {
      setEvents(data);
    })
    .catch((err) => console.error("API error:", err));
}, []);

  return <section className="pt-0">
      <Container>
        
        <Row className="g-4">
          
          {
          events.length === 0 ? (
        <p>Chargement des événements...</p>
      ) : (events.map((hotel, idx) => {
          return <Col key={idx} md={6} xl={4}>
                <HotelGridCard rowBean={hotel} />
              </Col>;
        }))}
        
        </Row>
        <Row>
          <Col xs={12}>
            
          </Col>
        </Row>
      </Container>
    </section>;
};
export default HotelGridLayout;