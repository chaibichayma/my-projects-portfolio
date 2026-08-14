import axios from 'axios';
const apiClient = axios.create({
  baseURL: 'http://localhost:3030/events/',
  headers: {
    'Content-Type': 'application/json',
  },
});
export default apiClient;