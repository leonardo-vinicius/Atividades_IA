# Problema dos Missionario e Canibais implementado em Ruby usando BFS (busca em largura)

class Estado
    attr_accessor :pai, :passo, :filhos

    def initialize(miss_e, miss_d, can_e, can_d, barco)
        @miss_d = miss_d
        @miss_e = miss_e
        @can_d = can_d
        @can_e = can_e
        @barco = barco
        @pai = nil
        @filhos = []
        @passo = nil
    end

    def ver_estados()
        puts "#{@miss_e} #{@miss_d} #{@can_e} #{@can_d} #{@barco} #{@passo}"
    end
     
    def verificar_solucao()
        @missionarios = false
        @cannibais = false
        
        if(@miss_d == 3 and @miss_e == 0)
            @missionarios = true
        end
        if(@can_d == 3 and @can_e == 0)
            @cannibais = true
        end
        
        @missionarios and @cannibais
    end
    
    def estado_valido()
        if(@miss_e > 3 or @miss_e < 0)
            return false
        end
        if(@miss_d > 3 or @miss_d < 0)
            return false
        end
        if(@can_e > 3 or @can_e < 0)
            return false
        end
        if(@can_d > 3 or @can_d < 0)
            return false
        end
        if((@miss_e == 0 or @miss_e >= @can_e) and (@miss_d == 0 or @miss_d >= @can_d))
            return true
        end
    end
    
    def gerar_filho()
        movimentos = [[1,0], [1,1],[2,0],[0,1],[0,2]]
        barco = 't'
        if(@barco == 'e')
            barco = 'd'
        elsif(@barco == 'd')
            barco = 'e'
        end
    
        movimentos.each do |movimento|
            miss_esq = 0
            miss_dir = 0
            can_esq = 0
            can_dir = 0
    
                if(barco == 'd')
                    @barco = 'e'
                    miss_esq = @miss_e - movimento[0]
                    miss_dir = @miss_d + movimento[0]
            
                    can_esq = @can_e - movimento[1]
                    can_dir = @can_d + movimento[1]
                elsif(barco == 'e')
                    @barco = 'd'
                    miss_esq = @miss_e + movimento[0]
                    miss_dir = @miss_d - movimento[0]
            
                    can_esq = @can_e + movimento[1]
                    can_dir = @can_d - movimento[1]
                end
            novo = Estado.new(miss_esq, miss_dir, can_esq, can_dir, barco)
            novo.pai = self
            novo.passo = movimento
            if(novo.estado_valido())
                self.filhos.append(novo)
            end
        end
    end
end
    
class Solucao
    attr_accessor :lista

    def initialize()
        @lista = []
        primeiro = Estado.new(3,0,3,0,'e')
        @lista.append(primeiro)
        @caminho = []
    end
    
    def gerar_solucao()
        @lista.each do |estado|
          if(estado.verificar_solucao())
                while(estado.pai != nil)
                    @caminho.insert(0, estado)
                    estado = estado.pai
                end
            break
          end

          estado.gerar_filho()
          estado.filhos.each do |j|
            @lista.append(j)
          end
        end
    end

    def mostrar_caminho()
        @caminho.each do |elemento|
            elemento.ver_estados
        end
    end
end
    
if __FILE__ == $0
    resolver = Solucao.new()
    resolver.gerar_solucao() 
    emoji_miss = "\u{1f474}"
    emoji_can = "\u{1f479}"
    puts "#{emoji_miss} #{emoji_miss} #{emoji_miss} Problema dos Missionarios e canibais #{emoji_can} #{emoji_can} #{emoji_can}"
    puts "MISSIONARIOS ESQ || MISSIONARIOS DIR || CANIBAIS ESQ || CANIBAIS DIR|| MOVIMENTO APLICADO (Missionarios, canibais)"
    resolver.mostrar_caminho()
end