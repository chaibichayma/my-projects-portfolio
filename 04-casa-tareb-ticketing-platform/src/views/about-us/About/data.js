import { FaCar, FaGlobeAmericas, FaHotel, FaPlane } from 'react-icons/fa';
import team3 from '@/assets/images/team/03.jpg';
import team4 from '@/assets/images/team/04.jpg';
import team5 from '@/assets/images/team/05.jpg';
import team6 from '@/assets/images/team/06.jpg';
const ourStories = [{
  title: 'Hotel Booking',
  description: 'A pleasure exertion if believed provided to. All led out world this music while asked.',
  icon: FaHotel,
  variant: 'bg-orange text-orange'
}, {
  title: 'Flight Booking',
  description: 'Warrant private blushes removed an in equally totally Objection do Mr prevailed.',
  icon: FaPlane,
  variant: 'bg-success text-success'
}, {
  title: 'Tour Booking',
  description: 'Dashwood does provide stronger is. But discretion frequently sir she instruments.',
  icon: FaGlobeAmericas,
  variant: 'bg-primary text-primary'
}, {
  title: 'Cab Booking',
  description: 'Imprudence attachment him his for sympathize. Large above be to means.',
  icon: FaCar,
  variant: 'bg-info text-info'
}];
const ourTeams = [{
  name: 'Larry Lawson',
  position: 'Editor in Chief',
  image: team3
}, {
  name: 'Louis Ferguson',
  position: 'Director Graphics',
  image: team4
}, {
  name: 'Louis Crawford',
  position: 'Editor, Coverage',
  image: team5
}, {
  name: 'Frances Guerrero',
  position: 'CEO, Coverage',
  image: team6
}];
export { ourStories, ourTeams };