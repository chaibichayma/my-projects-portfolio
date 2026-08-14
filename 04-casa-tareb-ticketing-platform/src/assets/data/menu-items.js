import { BsBell, BsBookmarkHeart, BsGear, BsGraphUpArrow, BsHeart, BsHouseDoor, BsJournals, BsPeople, BsPerson, BsStar, BsTicketPerforated, BsTrash, BsWallet } from 'react-icons/bs';
import { FaCar, FaEarthAmericas, FaHotel, FaPlane } from 'react-icons/fa6';
import { Link } from 'react-router-dom';
export const bookingHomeMenuItems = [{
  key: 'hotel-home',
  label: 'Hotel',
  url: '/hotels/home',
  icon: FaHotel
}, {
  key: 'flight-home',
  label: 'Flight',
  url: '/flights/home',
  icon: FaPlane
}, {
  key: 'tour-home',
  label: 'Tour',
  url: '/tours/home',
  icon: FaEarthAmericas
}, {
  key: 'cabs-home',
  label: 'Cab',
  url: '/cabs/home',
  icon: FaCar
}];
export const USER_PROFILE_MENU_ITEMS = [{
  key: 'acc-user-profile',
  label: 'My Profile',
  url: '/user/profile',
  parentKey: 'acc-user',
  icon: BsPerson
}, {
  key: 'acc-user-bookings',
  label: 'My Bookings',
  url: '/user/bookings',
  parentKey: 'acc-user',
  icon: BsTicketPerforated
}, {
  key: 'acc-user-travelers',
  label: 'Travelers',
  url: '/user/travelers',
  parentKey: 'acc-user',
  icon: BsPeople
}, {
  key: 'acc-user-payment-details',
  label: 'Payment Details',
  url: '/user/payment-details',
  parentKey: 'acc-user',
  icon: BsWallet
}, {
  key: 'acc-user-wishlist',
  label: 'Wishlist',
  url: '/user/wishlist',
  parentKey: 'acc-user',
  icon: BsHeart
}, {
  key: 'acc-user-settings',
  label: 'Settings',
  url: '/user/settings',
  parentKey: 'acc-user',
  icon: BsGear
}, {
  key: 'acc-user-delete',
  label: 'Delete Profile',
  url: '/user/delete-profile',
  parentKey: 'acc-user',
  icon: BsTrash
}];
export const AGENT_MENU_ITEMS = [{
  key: 'acc--dashboard',
  label: 'Dashboard',
  url: '/agent/dashboard',
  parentKey: 'acc-agent',
  icon: BsHouseDoor
}, {
  key: 'acc-agent-listings',
  label: 'Listings',
  url: '/agent/listings',
  parentKey: 'acc-agent',
  icon: BsJournals
}, {
  key: 'acc-agent-bookings',
  label: 'Bookings',
  url: '/agent/bookings',
  parentKey: 'acc-agent',
  icon: BsBookmarkHeart
}, {
  key: 'acc-agent-activities',
  label: 'Activities',
  url: '/agent/activities',
  parentKey: 'acc-agent',
  icon: BsBell
}, {
  key: 'acc-agent-earnings',
  label: 'Earnings',
  url: '/agent/earnings',
  parentKey: 'acc-agent',
  icon: BsGraphUpArrow
}, {
  key: 'acc-agent-reviews',
  label: 'Reviews',
  url: '/agent/reviews',
  parentKey: 'acc-agent',
  icon: BsStar
}, {
  key: 'acc-agent-settings',
  label: 'Settings',
  url: '/agent/settings',
  parentKey: 'acc-agent',
  icon: BsGear
}];
export const ADMIN_MENU_ITEMS = [{
  key: 'dashboard',
  label: 'Dashboard',
  url: '/admin/dashboard'
}, {
  key: 'pages-title',
  label: 'Pages',
  isTitle: true
}, {
  key: 'bookings',
  label: 'Bookings',
  children: [{
    key: 'bookings-list',
    label: 'Booking List',
    url: '/admin/bookings/list',
    parentKey: 'bookings'
  }, {
    key: 'bookings-detail',
    label: 'Booking Detail',
    url: '/admin/bookings/detail',
    parentKey: 'bookings'
  }]
}, {
  key: 'guests',
  label: 'Guests',
  children: [{
    key: 'guests-list',
    label: 'Guest List',
    url: '/admin/guests/list',
    parentKey: 'guests'
  }, {
    key: 'guests-detail',
    label: 'Guest Detail',
    url: '/admin/guests/detail',
    parentKey: 'guests'
  }]
}, {
  key: 'agents',
  label: 'Agents',
  children: [{
    key: 'agents-list',
    label: 'Agent List',
    url: '/admin/agents/list',
    parentKey: 'agents'
  }, {
    key: 'agents-detail',
    label: 'Agent Detail',
    url: '/admin/agents/detail',
    parentKey: 'agents'
  }]
}, {
  key: 'reviews',
  label: 'Reviews',
  url: '/admin/reviews'
}, {
  key: 'earnings',
  label: 'Earnings',
  url: '/admin/earnings'
}, {
  key: 'admin-settings',
  label: 'Admin Settings',
  url: '/admin/settings'
}, {
  key: 'admin-auth',
  label: 'Authentication',
  children: [{
    key: 'auth-sign-up',
    label: 'Sign Up',
    url: '/auth/sign-up',
    parentKey: 'admin-auth'
  }, {
    key: 'auth-sign-in',
    label: 'Sign in',
    url: '/auth/sign-in',
    parentKey: 'admin-auth'
  }, {
    key: 'auth-forgot-password',
    label: 'Forgot Password',
    url: '/auth/forgot-password',
    parentKey: 'admin-auth'
  }, {
    key: 'auth-two-factor-authentication',
    label: 'Two Factor Authentication',
    url: '/auth/two-factor-auth',
    parentKey: 'admin-auth'
  }, {
    key: 'auth-not-found',
    label: 'Error 404',
    url: '/not-found',
    target: '_blank',
    parentKey: 'admin-auth'
  }]
}];
export const HELP_MENU_ITEMS = [{
  key: 'help-center',
  label: 'Help Center',
  isTitle: true,
  children: [{
    key: 'helps-center-page',
    label: 'Help Center',
    url: '/help/center',
    parentKey: 'help-center'
  }, {
    key: 'helps-detail-page',
    label: 'Help Detail',
    url: '/help/detail',
    parentKey: 'help-center'
  }]
}, {
  key: 'helps-privacy-policy',
  label: 'Privacy Policy',
  url: '/help/privacy-policy',
  isTitle: true
}, {
  key: 'helps-service',
  label: 'Terms of Service',
  url: '/help/service',
  isTitle: true
}];
// menu-items.js
export const APP_MENU_ITEMS = [
  {
    key: 'Casa Tarab',
    label: 'Casa Tarab',
    url: '/',       // juste l'URL
    isTitle: false,
    children: [
      {
  key: 'casa-event',
  label: 'Evennements',
  url: '/',
  isTitle: true
},
 {
  key: 'casa-event-visite',
  label: 'Viste 3D',
  url: '/',
  isTitle: true
}
    ]
  }
];
