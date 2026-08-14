import { CardHeader, Col, Container, Row } from 'react-bootstrap';
const Hero = () => {
  return <section className="py-0">
      <Container>
        <div style={{height:5}}></div>
        <div >
          <Row>
            <Col md={12}>
              <CardHeader className="bg-transparent px-0 pt-0">
                  <h3 className="mb-0">Liste des commandes</h3>
                </CardHeader>
            </Col>
          </Row>
        </div>
      </Container>
    </section>;
};
export default Hero;