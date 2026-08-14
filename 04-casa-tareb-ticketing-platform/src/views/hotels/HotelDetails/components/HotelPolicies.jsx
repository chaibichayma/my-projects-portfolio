import { Card, CardBody, CardHeader } from 'react-bootstrap';
import { BsArrowRight, BsCheckCircleFill, BsXCircleFill } from 'react-icons/bs';
const policies = ['L’accès à l’événement : à partir de 18h00.', 'L’événement se termine à 23h00.', 'Les animaux ne sont pas autorisés.', 'Les fêtes privées ou comportements bruyants perturbant l’événement sont interdits.'];
const HotelPolicies = () => {
  return <Card className="bg-transparent">
      <CardHeader className="border-bottom bg-transparent px-0 pt-0">
        <h3 className="mb-0">Politiques de l’événement</h3>
      </CardHeader>
      <CardBody className="pt-4 p-0">
        <ul className="list-group list-group-borderless mb-2">
          <li className="list-group-item d-flex align-items-start">
            <BsCheckCircleFill className=" me-2" />
            L’événement est destiné à un public respectueux, merci de vous comporter de manière appropriée.
          </li>
          <li className="list-group-item d-flex align-items-start">
            <BsCheckCircleFill size={24} className=" me-2" />
            La consommation d’alcool et de tabac est autorisée dans les limites raisonnables, merci de ne pas déranger les autres participants.
          </li>
          <li className="list-group-item d-flex align-items-start">
            <BsCheckCircleFill size={18} className=" me-2" />
            Les drogues et substances illégales sont strictement interdites.
          </li>
          <li className="list-group-item d-flex align-items-start">
            <BsXCircleFill className=" me-2" />
            Pour toute modification ou annulation de votre billet, des frais applicables pourront s’appliquer.
          </li>
        </ul>
        <ul className="list-group list-group-borderless mb-2">
          {policies.map((item, idx) => {
          return <li key={idx} className="list-group-item h6 fw-light mb-0 items-center">
                <BsArrowRight className=" me-2" />
                {item}
              </li>;
        })}
        </ul>
        
      </CardBody>
    </Card>;
};
export default HotelPolicies;