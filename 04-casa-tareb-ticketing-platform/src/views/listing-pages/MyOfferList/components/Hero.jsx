import { CardHeader, Col, Container, Row } from 'react-bootstrap';
import { BsArrowRight } from 'react-icons/bs';
import backgroundImg from '@/assets/images/bg/07.jpg';
const Hero = () => {
  return <section className="py-0">
      <Container>
        <div style={{height:5}}></div>
        <div >
          <Row>
            <Col md={12}>
              <CardHeader className="bg-transparent px-0 pt-0">
                  <h3 className="mb-0">Mes réservations</h3>
                </CardHeader>
            </Col>
          </Row>
        </div>
      </Container>
    </section>;
};
export default Hero;