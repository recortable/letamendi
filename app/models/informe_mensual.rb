

class InformeMensual
  attr_accessor :mes, :anyo

  MES = %w{nada enero febrero marzo abril mayo junio julio agosto septiembre octubre noviembre diciembre}

  def initialize(anyo, mes)
    @mes = mes.to_i
    @anyo = anyo.to_i
  end

  def diarios
    diarios ||= (1..31).map do |day|
      Informe.new Time.utc(@anyo, @mes, day).to_db
    end
  end

  def el_mes
    MES[@mes]
  end
end