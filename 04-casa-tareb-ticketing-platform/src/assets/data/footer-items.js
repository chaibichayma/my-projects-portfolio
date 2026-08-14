import { FaCar, FaEarthAmericas, FaPlane, FaMusic, FaGuitar, FaUser, FaTicket } from 'react-icons/fa6';
const footerLinks = [{
  title: 'Page',
  items: [{
    name: 'À propos de nous',
    link: ''
  }, {
    name: 'Contactez-nous',
    link: ''
  }, {
    name: 'Actualités et blog',
    link: ''
  }, {
    name: 'Rencontre équipe',
    link: ''
  }]
}, {
  title: 'Lien',
  items: [{
    name: 'S\'inscrire',
    link: '/auth/sign-up'
  }, {
    name: 'Login',
    link: '/auth/sign-in'
  }, {
    name: 'Politique de confidentialité',
    link: ''
  }, {
    name: 'Termes',
    link: ''
  }, {
    name: 'Cookie'
  }, {
    name: 'Aide',
    link: ''
  }]
}, {
  title: 'Lieux & Scènes',
  items: [{
    name: 'Scènes principales'
  }, {
    name: 'Salles de concert'
  }, {
    name: 'Clubs & Bars'
  }, {
    name: 'Festivals en plein air'
  }, {
    name: 'Espaces communautaires'
  }]
}, {
  title: 'Événement',
  items: [{
    name: 'Concert',
    icon: FaMusic,
    link: ''
  }, {
    name: 'Festival',
    icon: FaGuitar,
    link: ''
  }, {
    name: 'Artiste',
    icon: FaUser,
    link: ''
  }, {
    name: 'Billet',
    icon: FaTicket,
    link: ''
  }]
}];
const topLinks = [{
  name: 'Événements',
  link: ''
}, {
  name: 'Salles',
  link: ''
}, {
  name: 'Artistes',
  link: ''
}, {
  name: 'Billets',
  link: ''
}, {
  name: 'À propos',
  link: ''
}, {
  name: 'Contactez-nous',
  link: ''
}, {
  name: 'Blogues',
  link: ''
}, {
  name: 'Services',
  link: ''
}, {
  name: 'Page de détail',
  link: ''
}, {
  name: 'Politique',
  link: ''
}, {
  name: 'Théâtre'
}, {
  name: 'Tech & Expositions'
}, {
  name: 'Rencontres fans'
}, {
  name: 'DJ Sets'
}, {
  name: 'Événements caritatifs'
}, {
  name: 'Soirées thématiques'
}, {
  name: 'Rencontres artistes'
}];
export { footerLinks, topLinks };