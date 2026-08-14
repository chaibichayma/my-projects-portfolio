import { SelectFormInput } from '@/components';
import { Card, CardBody, CardHeader, Col } from 'react-bootstrap';
import RoomCard from './RoomCard';
import { hotelRooms } from '../data';
const RoomOptions = () => {
  return <Card className="bg-transparent" id="room-options">
      <CardHeader className="border-bottom bg-transparent px-0 pt-0">
        <div className="d-sm-flex justify-content-sm-between align-items-center">
          <h3
  className="mb-2 mb-sm-0"
  style={{ marginTop: '10px', marginLeft: '27px' }}
>
  BILLETS
</h3>

          
        </div>
      </CardHeader>
      <CardBody className="pt-4 p-0 room-options-body">
  <div
    className="vstack gap-4 room-cards-wrapper"
    style={{
      marginLeft: '30px',   // espace à gauche
      marginRight: '800px',  // réduit un peu à droite
      maxWidth: 'calc(100% - 30px)', // largeur totale moins les marges
    }}
  >
    {hotelRooms.map((room, idx) => (
      <RoomCard
        key={idx}
        features={room.features}
        images={room.images}
        id={room.id}
        name={room.name}
        price={room.price}
        sale={room.sale}
        schemes={room.schemes}
      />
    ))}
  </div>
</CardBody>



    </Card>;
};
export default RoomOptions;


