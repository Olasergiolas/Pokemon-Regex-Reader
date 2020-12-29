%option noyywrap

    /*----Declaraciones-----*/

%{
#include "pokemonAscii.h"
#include <fstream>
#include <vector>

using namespace std;

ifstream input;

struct Pokemon{
    string nombre, tipo, sexo, num_pokedex, ascii;
    float peso, altura;
    int ps, attk, def;

    void mostrarInfo();
};

vector<bool> stats(9, false);
vector<Pokemon> listado_pokemon;
Pokemon aux;

void aniadirPokemon();
%}

LETRA   [A-Za-z]
PALABRA {LETRA}+
NOMBRE  "Char"{PALABRA}|{PALABRA}tle|"Blastoise"|{PALABRA}saur
DIGITO  [0-9]
ENTERO  {DIGITO}+
REAL    {ENTERO}"."{ENTERO}
ALTURA  ({ENTERO}|{REAL})m
PESO    ({ENTERO}|{REAL})kg
SEXO    "macho"|"hembra"
ATAQUE  {ENTERO}ATTK
DEFENSA {ENTERO}DEF
VIDA    {ENTERO}PS
NUMPOKEDEX  {DIGITO}{3,}
TIPO    "fuego"|"planta"|"agua"
linea   \n

%%

    /*----Reglas-----*/

{NOMBRE}    {
    aniadirPokemon();

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
    aux.tipo = YYText();
    stats[8] = true;
    }

\n   {}

<<EOF>> {
    aniadirPokemon();
    return 0;
    }

.   {}

%%

    /*----Procedimientos-----*/

int main (int argc, char *argv[])
{
    srand(time(NULL));
    unsigned pos;
    Pokemon pkmn_usuario, pkmn_rival;

    if (argc == 2)
    {
        input.open(argv[1]);
        if (!input) {
            cout << "Error de lectura" << endl;
        }
    }
    else {
        cout << "Falta archivo de entrada" << endl;
        exit(-1);
    }

    yyFlexLexer stream (&input,0);
    stream.yylex();

    cout << "\n¡Rival Azul quiere combatir!" << endl;
    pos = rand()%listado_pokemon.size();
    pkmn_rival = listado_pokemon[pos];
    listado_pokemon.erase(listado_pokemon.begin()+pos);
    cout << "Rival Azul va a sacar a " << pkmn_rival.nombre << '.' << endl << endl;

    cout << "Escoge Pokémon: " << endl;
    for (unsigned i = 0; i < listado_pokemon.size(); ++i)
        cout << '(' << i << ") - " << listado_pokemon[i].nombre << endl;
    do {
        cin >> pos;
    } while(pos < 0 || pos >= listado_pokemon.size());
    pkmn_usuario = listado_pokemon[pos];

    cout << "\nRival: ¡Adelante " << pkmn_rival.nombre << '!' << endl;
    pkmn_rival.mostrarInfo();

    cout << "\n\n¡Adelante " << pkmn_usuario.nombre << '!' << endl;
    pkmn_usuario.mostrarInfo();
}

void aniadirPokemon()
{
    bool add = true;
    for (unsigned i = 0; i < stats.size() && add; ++i){
        if (stats[i] == false)
            add = false;
    }

    if (add) {
        if (aux.nombre.compare("Bulbasaur") == 0)
            aux.ascii = bulbasaur;
        else if (aux.nombre.compare("Charmander") == 0)
            aux.ascii = charmander;
        else if (aux.nombre.compare("Squirtle") == 0)
            aux.ascii = squirtle;
        else
            aux.ascii.clear();
        listado_pokemon.push_back(aux); 
    }
}

void Pokemon::mostrarInfo() 
{
    cout << ascii << '[' << tipo << "] [" << sexo << "] "  << altura << "m " 
        << peso << "kg " << ps  << "PS " << attk << "ATTK " << def << "DEF " << endl;
}