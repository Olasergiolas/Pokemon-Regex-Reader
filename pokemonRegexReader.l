%option noyywrap

/*----Declaraciones-----*\

%{
#include "pokemonAscii.h"
#include <fstream>
#include <vector>

using namespace std;

ifstream input;

struct Pokemon{
    string nombre, tipo, sexo, num_pokedex;
    float peso, altura;
    int ps, attk, def;
}

vector<bool> stats(9, false);
vector<Pokemon> listado_pokemon;
Pokemon aux;
bool add = true;
%}

LETRA   [A-Za-z]
PALABRA {LETRA}+
NOMBRE  "Char"{PALABRA}|{PALABRA}tle|"Blastoise"|{PALABRA}saur
DIGITO  [0-9]
ENTERO  {DIGITO}+
REAL    {ENTERO}"."{ENTERO}
ALTURA  ({ENTERO}|{REAL})("m"|"cm")
PESO    ({ENTERO}|{REAL})("g"|"kg")
SEXO    "macho"|"hembra"
ATAQUE  {ENTERO}ATTK
DEFENSA {ENTERO}DEF
VIDA    {ENTERO}PS
NUMPOKEDEX  {DIGITO}{3,}
TIPO    "fuego"|"planta"|"agua"
linea   \n

%%

/*----Reglas-----*\

{NOMBRE}    {
    for (unsigned i = 0; i < stats.size() && add; ++i){
        if (v[i] == false)
            add = false;
    }

    if (add)
        listado_pokemon.push_back(aux);

    add = false;
    stats.clear();
    stats.assign(9, false);
    aux.nombre = YYText();
    stats[0] = true;
    }

{ALTURA}    {
    aux.altura = atof(YYText());
    stats[1] = true;
    }

{PESO}  {
    aux.peso = atof(YYText());
    stats[2] = true;
    }

{SEXO}  {
    aux.sexo = YYText();
    stats[3] = true;
    }

{ATAQUE}    {
    aux.attk = atoi(YYText());
    stats[4] = true;
    }

{DEFENSA}    {
    aux.def = atoi(YYText());
    stats[5] = true;
    }

{VIDA}    {
    aux.ps = atoi(YYText());
    stats[6] = true;
    }

{NUMPOKEDEX}    {
    aux.num_pokedex = YYText();
    stats[7] = true;
    }

{TIPO}    {
    aux.t = YYText();
    stats[8] = true;
    }

%%

/*----Procedimientos-----*\

int main (int argc, char *argv[])
{
    if (argc == 2)
    {
        input.open(argv[1]);
        if (input == 0) {
            cout << "Error de lectura" << endl;
        }
    }
    else
        exit(-1);

    yyFlexLexer stream (&fichero,0);
    stream.yylex();

    for (auto i : listado_pokemon) {
        cout << i.nombre << endl;
    }
}