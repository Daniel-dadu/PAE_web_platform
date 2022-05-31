#include <iostream>
#include <fstream>
using namespace std;

int main(){
    ofstream carreras_siglas("carreras_siglas.txt");
    ofstream carreras_nombres("carreras_nombres.txt");
    ofstream carreras_links("carreras_links.txt");

    ifstream carreras("carreras.txt");
    string line;

    while(getline(carreras, line)){
        //cout << line << " 1" << endl;
        carreras_siglas << line << endl;
        
        getline(carreras, line);
        //cout << line<< endl;
        carreras_nombres << line << endl;
        
        getline(carreras, line);
        //cout << line << endl;
        carreras_links << line << endl;
        getline(carreras, line);

    }

    carreras_siglas.close();
    carreras_nombres.close();
    carreras_links.close();
}