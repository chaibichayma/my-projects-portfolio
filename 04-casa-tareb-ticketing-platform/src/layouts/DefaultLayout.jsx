import { Preloader } from '@/components';
import { Suspense } from 'react';
const DefaultLayout = ({
  children
}) => {
  return <Suspense fallback={<Preloader />}>{children}</Suspense>;
};
export default DefaultLayout;