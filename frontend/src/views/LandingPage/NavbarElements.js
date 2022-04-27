import styled from 'styled-components';
import { NavLink as Link } from 'react-router-dom';
import { FaBars } from 'react-icons/fa';


export const Nav = styled.nav`
    background: #FFFFFF;
    height: 68px;
    display: flex;
    justify-content: space-between;
    padding: 0.5rem calc(( 100vw - 1500px ) / 2);
    z-index: 100;
    -webkit-box-shadow: 1px 8px 15px 5px rgba(0,0,0,0.18); 
    box-shadow: 1px 8px 15px 5px rgba(0,0,0,0.18);
    width: 70%;
    position: sticky;
    top: 0;


    @media screen and (max-width: 768px) {
        width: 100%;
    }

    @media only screen and (max-width: 992px) {
        padding: 0.5rem 2rem;
    }

`

export const NavLink = styled(Link)`
    color: #000;
    display: flex;
    align-items: center;
    text-decoration: none;
    padding: 0 1rem;
    height: 100%;
    cursor: pointer;
    font-size: 1.2rem;
    font-weight: 400;
    font-family: 'Dosis', sans-serif;

    @media only screen and (max-width: 992px) {
        font-size: 0.9rem;
        padding: 0 0.5rem;
    }


    &.active {
        color: #15cdfc;
    }
`

export const Bars = styled(FaBars)`
    display: none;
    color: #000;

    @media screen and (max-width: 768px) {
        display: block;
        position: absolute;
        top: 0;
        right: 0;
        transform: translate(-100%, 75%);
        font-size: 1.8rem;
        cursor: pointer;
    }
`

export const NavMenu = styled.div`
    display: flex;
    align-items: center;
    /* margin-top: -5px; */

    @media screen and (max-width: 768px) {
        display: none;
    }

`

export const NavBtn = styled.div`
    display: flex;
    align-items: center;
    margin-right: 24px;

    @media screen and (max-width: 768px){
        display: none;
    }
`

export const NavBtnLink = styled(Link)`
    border-radius: 4px;
    background: #256ce1;
    padding: 10px 22px;
    color: #fff;
    border: none;
    outline: none;
    cursor: pointer;
    transition: all 0.2s ease-in-out;
    text-decoration: none;

    &:hover {
        transition: all 0.2s ease-in-out;
        background: #fff;
        color: #010606;
    }
`