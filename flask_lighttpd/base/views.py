"""
"""
from flask import render_template

from . import base


@base.route('/')
#@base.route('/main')
def main():
    return render_template('base.html')
