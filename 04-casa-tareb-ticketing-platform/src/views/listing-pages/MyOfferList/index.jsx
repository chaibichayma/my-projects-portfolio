import { PageMetaData } from '@/components';
import FooterWithLinks from './components/FooterWithLinks';
import Hero from './components/Hero';
import TopNavBar4 from '../../hotels/Grid/components/TopNavBar4';
import MyOfferList from './components/MyOfferList';

const OfferDetail = () => {
  return <>
      <PageMetaData title="Offer Details" />

      <TopNavBar4 />
      <main>
        <Hero />
        <MyOfferList />
      </main>
      <FooterWithLinks />
    </>;
};
export default OfferDetail;