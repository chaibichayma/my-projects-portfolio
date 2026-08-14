

const rows = ["", "B", "C"];
const tables = Array.from({ length: 12 }, (_, i) => i + 1);

// Rangées en demi-cercle rouge
const semiCircleRows = [
  { start: 14, end: 23 }, // première rangée
  { start: 24, end: 33 }, // deuxième rangée
];

export default function Cinema() {
  return (
    <div className="cinema">
      {/* Tables avec chaises */}
      {rows.map((suffix, rowIndex) => (
        <div key={rowIndex} className="cinema-row">
          {tables.map((table, index) => {
            const middle = (tables.length - 1) / 2;
            const distance = index - middle;
            const offsetY = -Math.pow(distance, 2) * 2; // effet arc

            return (
              <div
                key={table}
                className="table-wrapper"
                style={{ transform: `translateY(${offsetY}px)` }}
              >
                <div className="table-code">{table}{suffix}</div>

                <div className="table-area">
                  <div className="chairs">
                    <div className="chair">1</div>
                    <div className="chair">2</div>
                    <div className="chair">3</div>
                  </div>

                  <div className="table-rect" />

                  <div className="chairs">
                    <div className="chair">4</div>
                    <div className="chair">5</div>
                    <div className="chair">6</div>
                  </div>
                </div>
              </div>
            );
          })}
        </div>
      ))}

    


    </div>
  );
}
