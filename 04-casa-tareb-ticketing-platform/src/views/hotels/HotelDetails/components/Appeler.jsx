// AppelerPayment.jsx
import React from "react";
import { PageMetaData } from '@/components';
import FooterWithLinks from './FooterWithLinks';
import TopNavBar4 from './TopNavBar4';
import PaymentPage from './PaymentPage';

const AppelerPayment = () => {
  return (
    <div>
      <TopNavBar4 />
      <main>
        <PaymentPage />
      </main>

      <FooterWithLinks />
    </div>
  );
};

export default AppelerPayment;
