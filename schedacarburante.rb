require 'sinatra'

get '/' do 
  erb :home
end

get '/scheda' do 
  scheda = Scheda.new(params[:scheda])
  scheda.calculate
  erb :scheda, :locals => { :scheda => scheda }
end

class Scheda
  
  attr_accessor :km_iniziali, :km_percorsi, :numero_rifornimenti, :rifornimenti, :media_km, :tolleranza, :totale

  def initialize(params = {})
    @prezzo_benzina = 160
    @tolleranza = 0.1
    @consumo = params[:consumo].to_f
    @km_iniziali = params[:km_iniziali].to_f
    @km_attuali = params[:km_attuali].to_f
    @km_percorsi = @km_attuali - @km_iniziali
    @numero_rifornimenti = params[:numero_rifornimenti].to_i
    @media_km = (@km_percorsi/@numero_rifornimenti).to_f
    @rifornimenti = []
    @totale = 0
  end
  
  def calculate
    km_totali = @km_iniziali
    @numero_rifornimenti.times do
      @rifornimenti << genera_rifornimento(km_totali)
      km_totali+= @rifornimenti.last[:km]
      @totale += @rifornimenti.last[:prezzo]
    end
  end 
  
  def genera_rifornimento(km_totali)
    prezzo_benzina = ((@prezzo_benzina)..(@prezzo_benzina+(@prezzo_benzina*@tolleranza))).to_a.sample/100.0
    rifornimento = {}
    rifornimento[:km] = (((@media_km - @media_km*@tolleranza).to_i..(@media_km + @media_km*@tolleranza).to_i).to_a.sample)
    rifornimento[:km_totali] = (km_totali+rifornimento[:km]).to_i
    rifornimento[:prezzo] = ((rifornimento[:km]/@consumo) * prezzo_benzina + 0.5).to_i
    return rifornimento
  end
  
end