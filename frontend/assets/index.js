const overlay = document.getElementById('overlay');
const query = new URLSearchParams(window.location.search);

class Widget {

  #endpoint = "http://localhost:3001/";

  #_region; #_gameName; #_tagLine;

  constructor(region, gameName, tagLine) {
    this.#_region = region;
    this.#_gameName = gameName;
    this.#_tagLine = tagLine;
  }

  async #instance() {
    const response = await fetch(`${this.#endpoint}?region=${this.#_region}&gamename=${this.#_gameName}&tagline=${this.#_tagLine}`);
    const { data } = await response.json();
    return data;
  }

  #elo(ranked) {
    const { tier, leaguePoints, rank} = ranked;
    const elo = `${tier} ${rank} - ${leaguePoints} Points`;
    Ranked.elo = elo
    return elo;
  }
  
  async search_player() {
    const data = await this.#instance();
    const rank = data.find(i => i.queueType == "RANKED_SOLO_5x5");
    if (!rank) throw new Error("player.no.elo");
    return this.#elo(rank);
  }
}

class Ranked {
  static elo = "";
}

async function run() {
  try {

    const region = query.get('region');
    const gameName = query.get('gamename');
    const tagLine = query.get('tagline');

    if (!region || !gameName || !tagLine)  return overlay.innerHTML = `Exemplo: ${window.location.hostname}?region=br&gamename=annie&tagline=annie`;
    
    const widget = new Widget(region, gameName, tagLine);
    const rank = await widget.search_player();
    overlay.innerHTML = rank;

  } catch (e) {
    if (e.message == "player.no.elo") return overlay.innerHTML = `${query.get('gamename')} não tem partidas ranqueadas.`;
    return overlay.innerHTML = Ranked.elo;
  };
};

run();