import { PageMetaData } from '@/components';
import AboutHotel from './components/AboutHotel';
import AvailabilityFilter from './components/AvailabilityFilter';
import FooterWithLinks from './components/FooterWithLinks';
import HotelGallery from './components/HotelGallery';
import Hero from '../Grid/components/Hero';
import TopNavBar4 from '../Grid/components/TopNavBar4';
const HotelDetails = (props) => {
  return <>
      <PageMetaData title="Hotel - Details" />
      <TopNavBar4 />
      <main>
        <Hero />
        <HotelGallery />
        <AboutHotel  />
      </main>

      <FooterWithLinks />
    </>;
};
export default HotelDetails;