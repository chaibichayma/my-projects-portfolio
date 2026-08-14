import GLightbox from 'glightbox';
import { useEffect, useRef } from 'react';
import clsx from 'clsx';
import 'glightbox/dist/css/glightbox.min.css';
const GlightBox = ({
  children,
  image,
  ...other
}) => {
  const ref = useRef(null);
  useEffect(() => {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    let instance = null;
    if (ref.current) {
      instance = new GLightbox({
        openEffect: 'fade',
        closeEffect: 'fade'
      });
    }
    return () => instance?.destroy();
  }, [ref]);
  return <a ref={ref} href={image} {...other} className={clsx('glightbox', other['className'])}>
      {children}
    </a>;
};
export default GlightBox;